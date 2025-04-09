//
//  Pages+Search.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import URLNavigator

extension Pages {
    enum Search: String {
        case main
        case detail
    }
}

extension Pages.Search: PagesProtocol {
    static func register(navigator: NavigatorProtocol) {
        navigator.register(Pages.Search.main.domain()) { url, values, context in
            return SearchMainViewController()
        }
        
        navigator.register(Pages.Search.detail.domain()) { url, values, context in
            guard let contextDict = context as? [URLNavigatorContextType: Any] else { return nil }
            guard let model = contextDict[.model] as? SearchResult else { return nil }
            return SearchDetailViewController(model: model)
        }
        
    }
    
    // MARK: - Base
    func base() -> String {
        return Pages.base + "/" + "\(type(of: self))" + "/"
    }
    
    // MARK: - Domain
    func domain() -> String {
        return Pages.myApp + self.base() + self.rawValue + "/"
    }
}
