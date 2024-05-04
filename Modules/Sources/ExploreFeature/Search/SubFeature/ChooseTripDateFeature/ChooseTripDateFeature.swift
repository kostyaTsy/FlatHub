//
//  ChooseTripDateFeature.swift
//
//
//  Created by Kostya Tsyvilko on 28.04.24.
//

import Foundation
import ComposableArchitecture
import FHCommon

@Reducer
public struct ChooseTripDateFeature {
    @ObservableState
    public struct State {
        var isCollapsed: Bool = true
        var startDate = Date()
        var endDate = Date()

        var selectedDatesRange: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"

            if startDate.isEqual(endDate, with: .day, .month, .year) {
                return dateFormatter.string(from: startDate)
            }

            let startDay = startDate.get(.day)
            let formattedEndDate = dateFormatter.string(from: endDate)

            return "\(startDay) - \(formattedEndDate)"
        }

        public init() {}
    }

    public enum Action {
        case onChangeCollapse(Bool)
        case onChangeStartDate(Date)
        case onChangeEndDate(Date)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onChangeCollapse(let isCollapsed):
                state.isCollapsed = isCollapsed
                return .none
            case .onChangeStartDate(let date):
                state.startDate = date
                if date > state.endDate {
                    state.endDate = date
                }
                return .none
            case .onChangeEndDate(let date):
                state.endDate = date
                return .none
            }
        }
    }
}
