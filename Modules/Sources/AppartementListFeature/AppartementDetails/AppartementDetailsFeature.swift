//
//  AppartementDetailsFeature.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import ComposableArchitecture
import FHRepository
import FHCommon

@Reducer
public struct AppartementDetailsFeature {
    enum Error: Swift.Error {
        case invalidDates
        case invalidCancelParams
    }

    @Reducer
    public enum Destination {
        case errorAlert(AlertState<ErrorAlertAction>)
        case cancelBookingAlert(AlertState<CancelBookingAlertAction>)
        case selectDates(SelectBookDatesFeature)
        case addReview(AddRatingFeature)
    }

    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var appartement: AppartementModel
        var details: AppartementInfoModel?

        var presentationType: AppartementDetailsPresentationType
        var dataModel: AppartementDetailsDataModel
        var cancelBookingParams: CancelBookingParams?

        var searchBookingDates: String? {
            dataModel.searchBookingDates
        }

        var searchBookingDatesPrice: Int {
            guard let startDate = dataModel.searchDates?.startDate,
                  let endDate = dataModel.searchDates?.endDate
            else {
                return 0
            }

            let dates = abs(endDate.daysBetween(startDate) ?? 0)
            return dates * appartement.pricePerNight
        }

        public init(
            appartement: AppartementModel,
            presentationType: AppartementDetailsPresentationType = .travelWithBooksDate,
            dataModel: AppartementDetailsDataModel = AppartementDetailsDataModel()
        ) {
            self.appartement = appartement
            self.presentationType = presentationType
            self.dataModel = dataModel
        }
    }

    public enum Action {
        case onAppear
        case onDetailsLoaded(AppartementInfoModel?)
        case onBackButtonTapped
        case onFavouriteButtonTapped
        case onFavouriteSuccess

        case onBookTapped
        case onBookRequest
        case onBookedSuccess
        case onBookedFailure(Swift.Error)

        case onCancelBookTapped
        case onCancelSuccess
        case onCancelFailure(Swift.Error)

        case onAddReviewTapped

        case shouldChooseDates
        case destination(PresentationAction<Destination.Action>)
    }

    public enum ErrorAlertAction {
        case done
    }

    public enum CancelBookingAlertAction {
        case confirmed
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.appartementRepository) var appartementRepository
    @Dependency(\.bookAppartementRepository) var bookAppartementRepository
    @Dependency(\.reviewRepository) var reviewRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [appartement = state.appartement] send in
                    let details = try? await appartementRepository.loadAppartementInfo(appartement.id)
                    guard let details else { return }
                    let infoModel = AppartementDetailsMapper.mapToAppartementInfoModel(from: details)
                    await send(.onDetailsLoaded(infoModel))
                    // TODO: add reviews in future
                }
            case .onDetailsLoaded(let infoModel):
                state.details = infoModel
                return .none
            case .onBackButtonTapped:
                return .run { send in
                    await dismiss()
                }
            case .onFavouriteButtonTapped:
                return .run { [appartement = state.appartement] send in
                    let user = accountRepository.user()
                    let requestDTO = AppartementMapper.mapToFavouriteAppartementDTO(
                        for: user.id, from: appartement.id
                    )
                    do {
                        if appartement.isFavourite {
                            try await appartementRepository.remoteAppartementFromFavourite(requestDTO)
                        } else {
                            try await appartementRepository.addAppartementToFavorite(requestDTO)
                        }
                        await send(.onFavouriteSuccess)
                    } catch {}
                }
            case .onFavouriteSuccess:
                state.appartement.isFavourite.toggle()
                return .none
            case .onBookTapped:
                if state.presentationType == .travelWithBooksDate {
                    return .send(.onBookRequest)
                }
                return .send(.shouldChooseDates)
            case .onBookRequest:
                return .run { [appartement = state.appartement, dataModel = state.dataModel] send in
                    guard let startDate = dataModel.searchDates?.startDate,
                          let endDate = dataModel.searchDates?.endDate
                    else {
                        await send(.onBookedFailure(Error.invalidDates))
                        return
                    }
                    let user = accountRepository.user()
                    let dto = AppartementDetailsMapper.mapToBookRequestDTO(
                        with: appartement,
                        userId: user.id,
                        startDate: startDate,
                        endDate: endDate
                    )
                    do {
                        try await bookAppartementRepository.bookAppartement(dto)
                        await send(.onBookedSuccess)
                    } catch {
                        await send(.onBookedFailure(error))
                    }
                }
            case .onBookedSuccess:
                state.presentationType = .travelBooked
                return .none
            case .onBookedFailure(let error):
                state.destination = .errorAlert(makeErrorAlert(error: error))
                return .none
            case .onCancelBookTapped:
                guard let cancellationPolicy = state.details?.cancellationPolicy,
                      let bookDates = state.dataModel.bookDates
                else {
                    return .none
                }
                let params = CancelBookingUtil.makeCancelBookingParams(
                    for: cancellationPolicy,
                    bookingStartDate: bookDates.startDate
                )

                guard params.canCancel else {
                    state.destination = .errorAlert(
                        makeErrorAlert(stringError: Strings.cannotCancelBookingErrorText)
                    )
                    return .none
                }

                state.cancelBookingParams = params

                let cancelMessage = String(
                    format: Strings.cancelBookingAlertMessage,
                    params.refundPercentage
                )
                state.destination = .cancelBookingAlert(
                    makeCancelBookingAlert(message: cancelMessage)
                )

                return .none
            case .onCancelSuccess:
                state.presentationType = .travelCancelled
                return .none
            case .onCancelFailure(let error):
                state.destination = .errorAlert(makeErrorAlert(error: error))
                return .none
            case .onAddReviewTapped:
                let ratingModel = AppartementDetailsMapper.mapToAddRatingModel(from: state.appartement)
                let reviewState = AddRatingFeature.State(dataModel: ratingModel)
                state.destination = .addReview(reviewState)
                return .none
            case .shouldChooseDates:
                let datesState = SelectBookDatesFeature.State(appartementId: state.appartement.id)
                state.destination = .selectDates(datesState)
                return .none
            case .destination(.presented(.cancelBookingAlert(.confirmed))):
                return .run { [id = state.dataModel.bookingId, params = state.cancelBookingParams] send in
                    guard let id, let params else {
                        await send(.onCancelFailure(Error.invalidCancelParams))
                        return
                    }
                    let cancelDTO = AppartementDetailsMapper.mapToCancelBookingDTO(
                        with: id,
                        with: params
                    )
                    do {
                        try await bookAppartementRepository.cancelBooking(cancelDTO)
                        await send(.onCancelSuccess)
                    } catch {
                        await send(.onCancelFailure(error))
                    }
                }
            case .destination(.presented(.selectDates(.onDatesApplied(let startDate, let endDate)))):
                state.dataModel.searchDates = SearchDates(
                    startDate: startDate,
                    endDate: endDate
                )
                return .send(.onBookRequest)
            case .destination:
                return .none
            }
        }.ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Alert

private extension AppartementDetailsFeature {
    private func makeErrorAlert(error: Swift.Error) -> AlertState<ErrorAlertAction> {
        AlertState {
            TextState(Strings.errorAlertTitle)
        } actions: {
            ButtonState(action: .done) {
                TextState(Strings.alertOkButtonText)
            }
        } message: {
            TextState(error.localizedDescription)
        }
    }

    private func makeErrorAlert(stringError: String) -> AlertState<ErrorAlertAction> {
        AlertState {
            TextState(Strings.errorAlertTitle)
        } actions: {
            ButtonState(action: .done) {
                TextState(Strings.alertOkButtonText)
            }
        } message: {
            TextState(stringError)
        }
    }

    private func makeCancelBookingAlert(message: String) -> AlertState<CancelBookingAlertAction> {
        AlertState {
            TextState(Strings.errorAlertTitle)
        } actions: {
            ButtonState(role: .cancel) {
                TextState(Strings.alertNoButtonText)
            }
            ButtonState(action: .confirmed) {
                TextState(Strings.alertYesButtonText)
            }
        } message: {
            TextState(message)
        }
    }
}
