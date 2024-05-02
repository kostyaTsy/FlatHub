//
//  BookList.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import SwiftUI
import ComposableArchitecture
import FHRepository
import FHCommon

public struct BookList: View {
    @Perception.Bindable private var store: StoreOf<BookListFeature>

    public init(store: StoreOf<BookListFeature>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                if !store.isDataLoaded {
                    ProgressView(Strings.loadingText)
                } else if store.isDataLoaded && store.books.isEmpty {
                    Text(Strings.noDataText)
                } else {
                    appartementListContent()
                }
            }
            .padding(.horizontal, Layout.Spacing.medium)
            .navigationDestination(
                store: store.scope(
                    state: \.$appartementDetails,
                    action: \.appartementDetails
                )
            ) { store in
                AppartementDetailsView(store: store)
            }
        }
    }

    @ViewBuilder private func appartementListContent() -> some View {
        ScrollView() {
            LazyVStack {
                ForEach(store.books) { book in
                    VStack(alignment: .leading) {
                        appartementHeader(book: book)
                        AppartementCell(
                            appartement: book.appartement,
                            shouldShowFavouriteIcon: false
                        )
                        .padding(.bottom, Layout.Spacing.big50)
                        .onTapGesture {
                            store.send(.onAppartementTapped(book))
                        }
                    }
                }
            }
        }
        .scrollIndicators(.never)
    }

    @ViewBuilder private func appartementHeader(book: BookModel) -> some View {
        if book.status == .booked {
            HStack {
                Text(book.datesRange)
                Icons.timerIcon
            }
            .font(Constants.appartementTitleFont)
        } else if book.status == .done {
            HStack {
                Text(book.datesRange)
                Icons.checkmarkSeal
                    .foregroundStyle(.green)
            }
            .font(Constants.appartementTitleFont)
        } else if book.status == .cancelled {
            HStack {
                Text(book.datesRange)
                    .strikethrough()
                Icons.closeIcon
                    .foregroundStyle(.red)
            }
            .font(Constants.appartementTitleFont)
        } else {
            Text(book.datesRange)
                .font(Constants.appartementTitleFont)
        }
    }
}

private extension BookList {
    enum Constants {
        static let appartementTitleFont = Font.system(size: 26, weight: .medium)
    }
}

#if DEBUG
    #Preview {
        let mockAppartement = AppartementModel(
            id: "",
            hostUserId: "",
            title: "Tiny house",
            city: "Minsk",
            countryCode: "BY",
            pricePerNight: 10,
            guestCount: 2
        )
        let mockBooks = Array(0...10).map { id in
            let appt = AppartementModel(
                id: "\(id)",
                hostUserId: "",
                title: "Tiny house",
                city: "Minsk",
                countryCode: "BY",
                pricePerNight: 10,
                guestCount: 2,
                photos: []
            )
            return BookModel(
                appartement: appt,
                status: .cancelled,
                startDate: Date.now,
                endDate: Date.now
            )
        }
        return BookList(
            store: .init(
                initialState: .init(books: mockBooks), reducer: {
                    BookListFeature()
                }
            )
        )
    }
#endif
