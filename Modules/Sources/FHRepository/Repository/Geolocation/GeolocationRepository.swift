//
//  GeolocationRepository.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public protocol GeolocationRepositoryProtocol {
    func loadGeocodeReverse(route: GeolocationRoute) async throws -> GeocodeReverseResponse
    func searchCity(with text: String) async throws -> [SearchCityResponse]
}

final public class GeolocationRepository: GeolocationRepositoryProtocol {
    enum Error: Swift.Error {
        case cannotReadJSON
    }

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

    public func searchCity(with text: String) async throws -> [SearchCityResponse] {
        guard let path = Bundle.module.path(forResource: "cities", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let cities = try? JSONDecoder().decode([SearchCityResponse].self, from: data)
        else {
            throw Error.cannotReadJSON
        }

        return cities.filter { $0.city.contains(text) }
    }
}
