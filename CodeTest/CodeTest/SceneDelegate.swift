//
//  SceneDelegate.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import UIKit

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let window = UIWindow()
    var coordinator: MainCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        #if DEBUG
        guard NSClassFromString("XCTest") == nil else {
            window.makeKeyAndVisible()
            window.rootViewController = UIViewController()
            return
        }
        #endif
        
        coordinator = MainCoordinator(window: window)
        coordinator?.start()
        window.windowScene = scene as? UIWindowScene
        window.makeKeyAndVisible()
    }
}

