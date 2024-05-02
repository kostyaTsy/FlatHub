//
//  BookListFeature.swift
//
//
//  Created by Kostya Tsyvilko on 2.05.24.
//

import ComposableArchitecture
import FHRepository

@Reducer
public struct BookListFeature {
    @ObservableState
    public struct State {
        var books: [BookModel]
        var isDataLoaded = false

        @Presents var appartementDetails: AppartementDetailsFeature.State?

        public init(books: [BookModel]) {
            self.books = books
            if !books.isEmpty {
                isDataLoaded = true
            }
        }
    }

    public enum Action {
        case onAppartementTapped(BookModel)
        case setBooksData([BookModel])
        case appartementDetails(PresentationAction<AppartementDetailsFeature.Action>)
    }

    @Dependency(\.accountRepository) var accountRepository
    @Dependency(\.appartementRepository) var appartementRepository

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppartementTapped(let bookModel):
                let user = accountRepository.user()
                let dataModel = AppartementDetailsMapper.mapToDataModel(
                    bookDates: BookDates(startDate: bookModel.startDate, endDate: bookModel.endDate)
                )
                state.appartementDetails = .init(
                    appartement: bookModel.appartement,
                    presentationType: user.role == .traveller ? .travelBooked : .hostBooked,
                    dataModel: dataModel
                )
                return .none
            case .setBooksData(let books):
                state.books = books
                state.isDataLoaded = true
                return .none
            case .appartementDetails:
                return .none
            }
        }.ifLet(\.$appartementDetails, action: \.appartementDetails) {
            AppartementDetailsFeature()
        }
    }
}
