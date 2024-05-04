//
//  ProfileUserViewConfiguration+Extension.swift
//
//
//  Created by Kostya Tsyvilko on 14.04.24.
//

import Foundation
import FHCommon
import FHRepository

extension ProfileUserView.Configuration {
    init(user: User) {
        self.init(name: user.userName, photoPath: user.profilePictureURL)
    }
}
