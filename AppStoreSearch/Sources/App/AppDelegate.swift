//
//  AppDelegate.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/13/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var dependency: AppDependency!
    var window: UIWindow?
    
    //MARK: - Init
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.dependency.configureAppearance()
        self.window = self.dependency.window
        self.window?.makeKeyAndVisible()
        return true
    }
}

