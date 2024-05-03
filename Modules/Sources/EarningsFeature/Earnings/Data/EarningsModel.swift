//
//  EarningsModel.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FHCommon

public struct EarningsModel: Identifiable {
    enum Status {
        case inProgress
        case done
    }

    public let id: UUID = UUID()
    let profit: Int
    let profitStartDate: Date
    let profitEndDate: Date
    let profitCreateDate: Date

    var status: Status {
        Date.now > profitEndDate ? .done : .inProgress
    }

    var datesRange: String {
        DateUtils.makeDatesRangeString(startDate: profitStartDate,
                                       endDate: profitEndDate)
    }
}
