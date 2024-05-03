//
//  EarningsFeature.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import Foundation
import ComposableArchitecture
import FHRepository
import FHCommon

@Reducer
public struct EarningsFeature {
    @ObservableState
    public struct State {
        var earnings: [EarningsModel] = []
        var isLoading = false
        var selectedMonth = Date.now.startOfMonth() ?? Date.now
        var isChartHidden = false

        var pendingProfit: Int = 0
        var earnedProfit: Int = 0

        var formattedMonth: String {
            DateUtils.makeFormattedDate(date: selectedMonth)
        }

        public init() {}
    }

    public enum Action {
        case onAppear
        case onLoadPaymentRequest(Date)
        case onEarningsLoaded([EarningsModel])
        case onMonthTapped
        case onNextMonthTapped
        case onPrevMonthTapped
    }

    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.paymentRepository) var paymentRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let date = state.selectedMonth
                return .send(.onLoadPaymentRequest(date))
            case .onLoadPaymentRequest(let date):
                state.isLoading = true
                return .run { send in
                    let user = accountRepository.user()
                    do {
                        let dto = try EarningsMapper.mapToLoadPaymentDTO(
                            for: user.id, for: date
                        )
                        let payments = try await paymentRepository.loadPayments(dto)
                        let earnings = payments.map { EarningsMapper.mapToEarningsModel(from: $0) }
                        await send(.onEarningsLoaded(earnings))
                    } catch {
                        await send(.onEarningsLoaded([]))
                    }
                }
            case .onEarningsLoaded(let earnings):
                state.earnings = earnings
                state.earnedProfit = earnings.filter { $0.status == .done }
                    .reduce(0) { $0 + $1.profit }
                state.pendingProfit =  earnings.filter { $0.status == .inProgress }
                    .reduce(0) { $0 + $1.profit }
                state.isLoading = false
                return .none
            case .onMonthTapped:
                state.isChartHidden.toggle()
                return .none
            case .onNextMonthTapped:
                let date = state.selectedMonth.nextMonth() ?? .now
                state.selectedMonth = date
                return .send(.onLoadPaymentRequest(date))
            case .onPrevMonthTapped:
                let date = state.selectedMonth.prevMonth() ?? .now
                state.selectedMonth = date
                return .send(.onLoadPaymentRequest(date))
            }
        }
    }
}
