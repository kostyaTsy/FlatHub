//
//  URL+Filename.swift
//
//
//  Created by Kostya Tsyvilko on 27.04.24.
//

import Foundation

public extension URL {
    func getFileNameWithoutExtension() -> String? {
        let fullFilename = self.lastPathComponent
        guard let dotIndex = fullFilename.firstIndex(of: ".") else {
            return nil
        }
        let filenameWithoutExtension = fullFilename[..<dotIndex]
        return String(filenameWithoutExtension)
    }

    func getFileExtension() -> String {
        self.pathExtension
    }
}
