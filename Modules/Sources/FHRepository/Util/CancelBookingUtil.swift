//
//  CancelBookingUtil.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

public struct CancelBookingParams {
    public let canCancel: Bool
    public let refundPercentage: Int
    public let policyType: CancellationPolicyType
}

public enum CancellationPolicyType: Int {
    case flexible = 1
    case standard
    case strict
}

public enum CancelBookingUtil {
    public static func makeCancelBookingParams(
        for policy: AppartementCancellationPolicyType,
        bookingStartDate: Date
    ) -> CancelBookingParams {
        let now = Date.now

        guard let cancellationType = CancellationPolicyType(rawValue: policy.id),
              let days = bookingStartDate.daysBetween(now)
        else {
            return CancelBookingParams(
                canCancel: false,
                refundPercentage: 0,
                policyType: .strict
            )
        }

        let daysBetweenStartBooking = abs(days)

        if cancellationType == .flexible, daysBetweenStartBooking > 3 {
            return CancelBookingParams(
                canCancel: true,
                refundPercentage: 100,
                policyType: cancellationType
            )
        } else if cancellationType == .standard, daysBetweenStartBooking > 7 {
            return CancelBookingParams(
                canCancel: true,
                refundPercentage: 80,
                policyType: cancellationType
            )
        } else {
            return CancelBookingParams(
                canCancel: false,
                refundPercentage: 0,
                policyType: cancellationType
            )
        }
    }
}
