//
//  UserDefaults+Codable.swift
//
//
//  Created by Kostya Tsyvilko on 31.03.24.
//

import Foundation

public extension UserDefaults {
    func set(_ value: Encodable, for key: String) throws {
        let encoder = JSONEncoder()
        let encodedValue = try encoder.encode(value)
        set(encodedValue, forKey: key)
    }

    func object<T: Decodable>(for key: String) throws -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
