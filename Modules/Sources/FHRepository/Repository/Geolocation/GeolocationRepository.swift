//
//  GeolocationRepository.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public protocol GeolocationRepositoryProtocol {
    func loadGeocodeReverse(route: GeolocationRoute) async throws -> GeocodeReverseResponse
}

final public class GeolocationRepository: GeolocationRepositoryProtocol {
    private let apiManager: APIManager

    public init(apiManager: APIManager = URLSessionManager()) {
        self.apiManager = apiManager
    }

    public func loadGeocodeReverse(route: GeolocationRoute) async throws -> GeocodeReverseResponse {
        let request = try URLRequestBuilder.build(from: route)

        let result = await apiManager.send(request: request)
        switch result {
        case .success(let data):
            let response = try JSONDecoder().decode(GeocodeReverseResponse.self, from: data)
            return response
        case .failure(let error):
            throw error
        }
    }
}
