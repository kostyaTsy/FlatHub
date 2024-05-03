//
//  BookAppartementMapper.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation

enum BookAppartementMapper {
    static func mapToBookAppartement(
        from dto: BookAppartementRequestDTO,
        with appartement: AppartementDTO
    ) -> BookAppartementDTO {
        BookAppartementDTO(
            id: dto.id,
            userId: dto.userId,
            hostUserId: dto.hostUserId,
            startDate: dto.startDate,
            endDate: dto.endDate,
            bookDate: Date.now,
            status: .booked,
            appartement: appartement
        )
    }

    static func mapToPaymentDTO(
        from dto: BookAppartementRequestDTO,
        with appartement: AppartementDTO
    ) -> PaymentDTO {
        let bookDaysCount = dto.startDate.daysBetween(dto.endDate) ?? 1
        return PaymentDTO(
            bookingId: dto.id,
            userId: dto.userId,
            hostUserId: dto.hostUserId,
            appartementId: dto.appartementId,
            amount: bookDaysCount * appartement.pricePerNight,
            bookStartDate: dto.startDate,
            bookEndDate: dto.endDate,
            createDate: Date.now
        )
    }

    static func mapToUpdatePaymentDTO(
        from dto: CancelBookingDTO
    ) -> UpdatePaymentDTO {
        UpdatePaymentDTO(
            bookingId: dto.bookingId,
            refundPercentage: dto.refundPercentage
        )
    }
}
