//
//  AppartementRepository.swift
//
//
//  Created by Kostya Tsyvilko on 1.04.24.
//

import Foundation
import FirebaseFirestore

public protocol AppartementRepositoryProtocol {}

public final class AppartementRepository: AppartementRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }
}
