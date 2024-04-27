//
//  ChooseLocationFeature.swift
//
//
//  Created by Kostya Tsyvilko on 20.04.24.
//

import ComposableArchitecture
import CoreLocation
import MapKit

@Reducer
public struct ChooseLocationFeature {
    @ObservableState
    public struct State {
        var locationRegion = Constants.defaultLocationCoordinates

        var location: ChooseLocationModel {
            ChooseLocationModel(
                longitude: locationRegion.center.longitude,
                latitude: locationRegion.center.latitude
            )
        }

        public init() {}
    }

    public enum Action {
        case onAppear
        case setLocation(ChooseLocationModel)
        case onMapLocationChanged(MKCoordinateRegion)
    }

    // TODO: Add custom location manager and receive user location
    private let locationManager: CLLocationManager

    public init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                locationManager.requestWhenInUseAuthorization()
                return .none
            case .setLocation(let location):
                state.locationRegion.center = .init(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                return .none
            case .onMapLocationChanged(let region):
                state.locationRegion = region
                return .none
            }
        }
    }
}

private extension ChooseLocationFeature {
    enum Constants {
        static let defaultLocationCoordinates = MKCoordinateRegion(
            center: .init(latitude: 53.893009, longitude: 27.567444),
            span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}
