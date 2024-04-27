//
//  APIManager.swift
//
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public typealias APIManagerResult = Result<Data, Error>

public protocol APIManager {
    func send(request: URLRequest) async -> APIManagerResult
}
