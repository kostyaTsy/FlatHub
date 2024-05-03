//
//  AddRatingFeature.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import ComposableArchitecture
import FHRepository

@Reducer
public struct AddRatingFeature {
    @ObservableState
    public struct State {
        var dataModel: AddRatingModel
        var isLoading: Bool = false
        var appartementRating: Int = 5
        var appartementReviewText: String = ""

        var hostRating: Int = 5
        var hostReviewText: String = ""
        
        init(dataModel: AddRatingModel) {
            self.dataModel = dataModel
        }
    }

    public enum Action {
        case onAppartementRatingChange(Int)
        case onAppartementReviewTextChange(String)
        case onHostRatingChange(Int)
        case onHostReviewTextChange(String)
        case onReviewButtonTapped
        case onReviewDone
        case onCloseIconTapped
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.reviewRepository) var reviewRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppartementRatingChange(let rating):
                state.appartementRating = rating
                return .none
            case .onAppartementReviewTextChange(let text):
                state.appartementReviewText = text
                return .none
            case .onHostRatingChange(let rating):
                state.hostRating = rating
                return .none
            case .onHostReviewTextChange(let text):
                state.hostReviewText = text
                return .none
            case .onReviewButtonTapped:
                state.isLoading = true
                return .run { [state] send in
                    let user = accountRepository.user()
                    let reviewDTO = AddRatingMapper.mapToReviewRequestDTO(
                        from: state.dataModel,
                        userId: user.id,
                        appartementRating: state.appartementRating,
                        appartementReviewText: state.appartementReviewText,
                        hostRating: state.hostRating,
                        hostReviewText: state.hostReviewText
                    )

                    try? await reviewRepository.addReview(reviewDTO)
                    await send(.onReviewDone)
                }
            case .onReviewDone:
                state.isLoading = false
                return .run { send in
                    await dismiss()
                }
            case .onCloseIconTapped:
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
