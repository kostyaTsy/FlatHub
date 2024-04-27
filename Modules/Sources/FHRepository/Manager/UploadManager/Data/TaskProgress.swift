//
//  File.swift
//  
//
//  Created by Kostya Tsyvilko on 21.04.24.
//

import Foundation

public struct TaskProgress {
    public let completedCount: Int64
    public let totalCount: Int64
    public let fractionCompleted: Double

    public init(
        completedCount: Int64,
        totalCount: Int64,
        fractionCompleted: Double
    ) {
        self.completedCount = completedCount
        self.totalCount = totalCount
        self.fractionCompleted = fractionCompleted
    }
}
