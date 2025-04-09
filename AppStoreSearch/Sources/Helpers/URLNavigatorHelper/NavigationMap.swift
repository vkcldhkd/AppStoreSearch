//
//  NavigationMap.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import URLNavigator

enum NavigationMap {
    static func initialize(navigator: NavigatorProtocol) {
        Pages.Alert.register(navigator: navigator)
        Pages.Search.register(navigator: navigator)
    }
}
