//
//  AppDelegate.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // SwiftUI 뷰 설정
        let rootView = ContentView()
        window.rootViewController = UIHostingController(rootView: rootView)

        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}
