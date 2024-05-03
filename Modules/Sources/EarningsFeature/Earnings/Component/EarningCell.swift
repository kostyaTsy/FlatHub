//
//  EarningCell.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import SwiftUI
import FHCommon

struct EarningCell: View {
    private let earningModel: EarningsModel

    init(earningModel: EarningsModel) {
        self.earningModel = earningModel
    }

    var body: some View {
        content()
    }

    @ViewBuilder private func content() -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.small) {
            HStack {
                Text(earningModel.datesRange)
                if earningModel.status == .inProgress {
                    Icons.timerIcon
                } else if earningModel.status == .done {
                    Icons.checkmarkSeal
                        .foregroundStyle(.green)
                }
            }
            .font(Constants.datesRangeFont)

            Text(
                String(format: earningModel.status == .done ? Strings.earnedText : Strings.pendingText,
                       earningModel.profit)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension EarningCell {
    enum Constants {
        static let datesRangeFont = Font.system(size: 20, weight: .medium)
    }
}

#if DEBUG
    #Preview {
        EarningCell(
            earningModel: EarningsModel(
                profit: 100,
                profitStartDate: Date.now,
                profitEndDate: Date.now,
                profitCreateDate: Date.now
            )
        )
    }
#endif
