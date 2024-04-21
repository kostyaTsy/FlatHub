//
//  GeolocationRoute.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public enum GeolocationRoute {
    case reverseGeocode(_ latitude: Double, _ longitude: Double)
}

extension GeolocationRoute: APIRoute {
    public var baseURL: String {
        switch self {
        case .reverseGeocode:
            "https://api.geoapify.com"
        }
    }
    
    public var path: String {
        switch self {
        case .reverseGeocode(let latitude, let longitude):
            // TODO: paste your api key
            let apiKey = APIConstants.geoapifyKey
            return "/v1/geocode/reverse?lat=\(latitude)&lon=\(longitude)&apiKey=\(apiKey)"
        }
    }
    
    public var method: RequestMethod {
        return .get
    }
    
    public var headers: [String : String] {
        return [:]
    }
}
