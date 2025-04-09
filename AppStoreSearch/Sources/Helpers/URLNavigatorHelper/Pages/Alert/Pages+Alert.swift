//
//  Pages+Alert.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import UIKit
import URLNavigator

extension Pages {
    enum Alert: String {
        case confirm
    }
}

extension Pages.Alert: PagesProtocol {
    // MARK: - Register
    static func register(navigator: NavigatorProtocol) {
        navigator.register(Pages.Alert.confirm.domain()) { url, values, context in
            guard let contextDict = context as? [URLNavigatorContextType: Any] else { return nil }
            return UIAlertController(
                title: contextDict[.title] as? String,
                message: contextDict[.message] as? String,
                preferredStyle: .alert
            ).then {
                $0.addAction(UIAlertAction.init(title: "확인", style: .default))
            }
        }
    }
    
    // MARK: - Base
    func base() -> String {
        return Pages.base + "/" + "\(type(of: self))" + "/"
    }
    
    // MARK: - Domain
    func domain() -> String {
        return Pages.myApp + self.rawValue + "/"
    }
}
