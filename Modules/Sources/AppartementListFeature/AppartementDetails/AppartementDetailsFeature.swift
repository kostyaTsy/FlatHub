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

public enum AppartementDetailsPresentationType {
    case travelWithBooksDate
    case travelWithoutBooksDate
    case travelBooked

    var shouldShowBookButton: Bool {
        [.travelWithBooksDate, .travelWithoutBooksDate].contains(self)
    }
}

@Reducer
public struct AppartementDetailsFeature {
    enum Error: Swift.Error {
        case invalidDates
    }
    @Reducer
    public enum Destination {
        case alert(AlertState<AlertAction>)
        case selectDates(SelectBookDatesFeature)
    }

    @ObservableState
    public struct State {
        @Presents var destination: Destination.State?
        var appartement: AppartementModel
        var presentationType: AppartementDetailsPresentationType
        var dataModel: AppartementDetailsDataModel

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
        case onBookTapped
        case onBookRequest
        case onBookedSuccess
        case onBookedFailure(Swift.Error)
        case shouldChooseDates
        case destination(PresentationAction<Destination.Action>)
    }

    public enum AlertAction {
        case done
    }

    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.bookAppartementRepository) var bookAppartementRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
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
                state.destination = .alert(makeErrorAlert(error: error))
                return .none
            case .shouldChooseDates:
                let datesState = SelectBookDatesFeature.State(appartementId: state.appartement.id)
                state.destination = .selectDates(datesState)
                return .none
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
    private func makeErrorAlert(error: Swift.Error) -> AlertState<AlertAction> {
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
}
