//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol APIRoute {
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get }
}
