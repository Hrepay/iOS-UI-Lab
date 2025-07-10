//
//  SceneDelegate.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        // SwiftUI 뷰 설정
        let rootView = ContentView()
        window.rootViewController = UIHostingController(rootView: rootView)

        self.window = window
        window.makeKeyAndVisible()
    }
}
