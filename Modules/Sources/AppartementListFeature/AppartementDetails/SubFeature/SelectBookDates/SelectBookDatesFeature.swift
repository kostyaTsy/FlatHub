//
//  SelectBookDatesFeature.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import ComposableArchitecture
import FHRepository

@Reducer
public struct SelectBookDatesFeature {
    @ObservableState
    public struct State {
        var appartementId: String
        var startDate = Date.now
        var endDate = Date.now

        public init(appartementId: String) {
            self.appartementId = appartementId
        }
    }

    public enum Action {
        case onStartDateChange(Date)
        case onEndDateChange(Date)
        case onApplyTapped
        case onDatesApplied(Date, Date)
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.bookAppartementRepository) var bookAppartementRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onStartDateChange(let date):
                state.startDate = date
                return .none
            case .onEndDateChange(let date):
                state.endDate = date
                return .none
            case .onApplyTapped:
                let startDate = state.startDate
                let endDate = state.endDate
                return .send(.onDatesApplied(startDate, endDate))
            case .onDatesApplied:
                return .run { send in
                    await dismiss()
                }
            }
        }
    }
}
