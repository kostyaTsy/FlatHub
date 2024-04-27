//
//  URLSessionManger.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

final public class URLSessionManager: APIManager {
    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public func send(request: URLRequest) async -> APIManagerResult {
        do {
            let result = try await session.data(for: request)

            return .success(result.0)
        } catch {
            return .failure(error)
        }
    }
}
