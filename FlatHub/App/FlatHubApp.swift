//
//  FlatHubApp.swift
//  FlatHub
//
//  Created by Kostya Tsyvilko on 23.03.24.
//

import SwiftUI
import FHAuth
import AppFeature
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct FlatHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .init(), reducer: {
                        AppFeature()
                    }
                )
            )
        }
    }
}
