//
//  URLNavigatorHelper.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import URLNavigator

final class URLNavigatorHelper {
    static let shared = URLNavigatorHelper()
    let navigator = Navigator()
    
    init() {
        NavigationMap.initialize(navigator: self.navigator)
    }
}

extension URLNavigatorHelper {
    func go(
        name: PagesProtocol,
        type: URLNavigatorType = .push,
        context: [URLNavigatorContextType: Any?] = [:]
    ) {
        switch type {
        case .present:
            self.navigator.present(
                name.domain(),
                context: context,
                wrap: BaseNavigationController.self
            )
        case .push:
            self.navigator.push(name.domain(), context: context)

        case .open:
            self.navigator.open(name.domain(), context: context)
        }
    }
    
    func alert(
        title: String?,
        message: String?,
        alertName: PagesProtocol = Pages.Alert.confirm
    ) {
        let param: [URLNavigatorContextType: Any?] = [
            .title: title,
            .message: message
        ]
        
        self.navigator.present(
            alertName.domain(),
            context: param
        )
    }
}
