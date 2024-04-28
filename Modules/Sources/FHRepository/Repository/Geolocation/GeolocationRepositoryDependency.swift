//
//  GeolocationRepositoryDependency.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation
import Dependencies

public struct GeolocationRepositoryDependency: Sendable {
    public var loadGeocodeReverse: @Sendable (_ route: GeolocationRoute) async throws -> GeocodeReverseResponse
    public var searchCity: @Sendable (_ text: String) async throws -> [SearchCityResponse]
}

// MARK: - Live

extension GeolocationRepositoryDependency {
    static func live(
        repository: GeolocationRepositoryProtocol = GeolocationRepository()
    ) -> GeolocationRepositoryDependency {
        let dependency = GeolocationRepositoryDependency(
            loadGeocodeReverse: { route in
                try await repository.loadGeocodeReverse(route: route)
            }, searchCity: { query in
                try await repository.searchCity(with: query)
            }
        )

        return dependency
    }
}

// MARK: - Preview

extension GeolocationRepositoryDependency {
    static func mock() -> GeolocationRepositoryDependency {
        let dependency = GeolocationRepositoryDependency(
            loadGeocodeReverse: { route in
                GeocodeReverseResponse(
                    features: [
                        GeocodeReverseFeature(
                            type: "Mock",
                            properties: GeocodeReverseProperties(
                                country: "Belarus",
                                countryCode: "by",
                                city: "Minsk"
                            )
                        )
                    ]
                )
            }, searchCity: { _ in
                [
                    SearchCityResponse(city: "Minsk", countryCode: "BY")
                ]
            }
        )

        return dependency
    }
}

// MARK: - Dependency

extension GeolocationRepositoryDependency: DependencyKey {
    public static var liveValue: GeolocationRepositoryDependency {
        GeolocationRepositoryDependency.live()
    }

    public static var previewValue: GeolocationRepositoryDependency {
        GeolocationRepositoryDependency.mock()
    }

    public static var testValue: GeolocationRepositoryDependency {
        GeolocationRepositoryDependency.mock()
    }
}

extension DependencyValues {
    public var geolocationRepository: GeolocationRepositoryDependency {
        get { self[GeolocationRepositoryDependency.self] }
        set { self[GeolocationRepositoryDependency.self] = newValue }
    }
}
