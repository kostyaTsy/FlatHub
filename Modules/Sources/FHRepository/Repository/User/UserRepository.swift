//
//  UserRepository.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UserRepositoryProtocol {
    func load(userId: String) async throws -> User
    func save(user: User) async throws
}

final public class UserRepository: UserRepositoryProtocol {
    private let store: Firestore

    public init(store: Firestore = Firestore.firestore()) {
        self.store = store
    }

    public func load(userId: String) async throws -> User {
        let document = try await getUserDocument(for: userId)

        guard document.exists else {
            throw FHRepositoryError.noData
        }

        return try document.data(as: User.self)
    }
    
    public func save(user: User) async throws {
        try store.collection(DBTableName.userTable)
            .document(user.id)
            .setData(from: user)
    }
}

// MARK: - Document
private extension UserRepository {
    private func getUserDocument(for userId: String) async throws -> DocumentSnapshot {
        try await store.collection(DBTableName.userTable)
            .document(userId)
            .getDocument()
    }
}
