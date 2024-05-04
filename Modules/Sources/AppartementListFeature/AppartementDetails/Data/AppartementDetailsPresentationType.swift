//
//  AppartementDetailsPresentationType.swift
//
//
//  Created by Kostya Tsyvilko on 3.05.24.
//

import Foundation
import FHRepository

public enum AppartementDetailsPresentationType {
    case travelWithBooksDate
    case travelWithoutBooksDate
    /// Indicates that traveller opens book details screen
    case travelBooked
    /// Indicates that host opens book details screen
    case hostBooked
    case travelCancelled
    case bookedDone

    var shouldShowBookButton: Bool {
        [.travelWithBooksDate, .travelWithoutBooksDate].contains(self)
    }

    var shouldShowCancelBookButton: Bool {
        [.travelBooked].contains(self)
    }

    var shouldShowReviewButton: Bool {
        [.bookedDone].contains(self)
    }

    var shouldShowFavouriteButton: Bool {
        [.travelWithBooksDate, .travelWithoutBooksDate].contains(self)
    }

    init(user: User, bookStatus: BookStatus) {
        if bookStatus == .cancelled {
            self = .travelCancelled
            return
        } else if bookStatus == .done && user.role == .traveller {
            self = .bookedDone
            return
        }

        self = user.role == .host ? .hostBooked : .travelBooked
    }
}
