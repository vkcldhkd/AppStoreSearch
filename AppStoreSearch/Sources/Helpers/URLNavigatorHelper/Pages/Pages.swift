//
//  Pages.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import URLNavigator

protocol PagesProtocol {
    func domain() -> String
    func base() -> String
    static func register(navigator: NavigatorProtocol)
}

struct Pages {
    static let myApp: String = "AppStoreSearch://"
    static let base: String = "Pages"
}
