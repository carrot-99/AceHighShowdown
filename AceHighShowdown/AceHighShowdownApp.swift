//  AceHighShowdownApp.swift

import SwiftUI
import GoogleMobileAds

@main
struct AceHighShowdownApp: App {
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
