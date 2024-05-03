//
//  ChartView.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import SwiftUI
import Charts

struct ChartView: View {
    private let earnings: [EarningsModel]

    init(earnings: [EarningsModel]) {
        self.earnings = earnings
    }

    var body: some View {
        Chart {
            ForEach(earnings) { item in
                BarMark(
                    x: .value("", item.profitCreateDate),
                    y: .value("", item.profit)
                )
            }
        }
    }
}

#if DEBUG
    #Preview {
        let mockEarnings = Array(6...25).map {
            var dateComponents = DateComponents()
            dateComponents.year = 2024
            dateComponents.month = 5
            dateComponents.day = $0

            let userCalendar = Calendar(identifier: .gregorian)
            let date = userCalendar.date(from: dateComponents)

            return EarningsModel(
                profit: Int.random(in: 10...250),
                profitStartDate: Date.now,
                profitEndDate: Date.now,
                profitCreateDate: date ?? .now
            )
        }
        return ChartView(
            earnings: mockEarnings
        )
    }
#endif
