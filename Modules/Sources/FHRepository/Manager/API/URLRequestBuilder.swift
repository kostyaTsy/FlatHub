//
//  URLRequestBuilder.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

enum URLRequestBuilderError: Error {
    case invalidURL
}

enum URLRequestBuilder {
    static func build(from route: APIRoute) throws -> URLRequest {
        guard let url = URL(string: route.baseURL + route.path) else {
            throw URLRequestBuilderError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        request.allHTTPHeaderFields = route.headers

        return request
    }
}
