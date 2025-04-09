//
//  CompositionRoot.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/13/24.
//

import UIKit
import Kingfisher

final class CompositionRoot {
    static func resolve() -> AppDependency {
        // MARK: - Window
//        KeyChainHelper.shared.migration()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.rootViewController = BaseNavigationController(rootViewController: SearchMainViewController())
        window.makeKeyAndVisible()
         
        
        return AppDependency(
            window: window,
            configureAppearance: self.configureAppearance
        )
    }
    
    static func configureAppearance() {
        print("\(#function) AppDependency configureAppearance")
        KingfisherManager.shared.defaultOptions += CompositionRoot.configureKingfisherDefaultAppearance()
        CompositionRoot.configureTableViewAppearance()
    }
}

// MARK: - TableView
private extension CompositionRoot {
    static func configureTableViewAppearance() {
        UITableView.appearance().separatorColor = UIColor.clear
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorInset = .zero
    }
}

// MARK: - Kingfisher
extension CompositionRoot {
    static func configureKingfisherDefaultAppearance() -> KingfisherOptionsInfo {
        return [
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .transition(.fade(0.6))
        ]
    }
}
