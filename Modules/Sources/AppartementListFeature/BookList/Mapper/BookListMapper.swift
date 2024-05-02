//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import Foundation
import FHRepository

public enum BookListMapper {
    public static func mapToBookModel(
        from book: BookAppartementDTO
    ) -> BookModel {
        var bookStatus: BookStatus
        
        if let status = BookStatus(rawValue: book.status), status == .done {
            bookStatus = .cancelled
        } else if Date.now > book.endDate {
            bookStatus = .done
        } else {
            bookStatus = .booked
        }

        return BookModel(
            appartement: AppartementMapper.mapToAppartementModel(from: book.appartement),
            status: bookStatus,
            startDate: book.startDate,
            endDate: book.endDate
        )
    }
}
