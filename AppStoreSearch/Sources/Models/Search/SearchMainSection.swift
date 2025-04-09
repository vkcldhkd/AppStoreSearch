//
//  SearchMainSection.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import RxDataSources

enum SearchMainSection {
    case history([SearchMainSectionItem])
    case search([SearchMainSectionItem])
    case result([SearchMainSectionItem])
}

extension SearchMainSection: SectionModelType {
//    typealias Item = SearchMainSectionItem
//    typealias Identity = String
    
    var items: [Item] {
        switch self {
        case let .history(items): return items
        case let .search(items): return items
        case let .result(items): return items
        }
    }
    
//    var identity: String {
//        switch self {
//        case .history: return "history"
//        case .search: return "search"
//        case .result: return "result"
//        }
//    }
    
    init(original: SearchMainSection, items: [SearchMainSectionItem]) {
        switch original {
        case .history: self = .history(items)
        case .search: self = .search(items)
        case .result: self = .result(items)
        }
    }
}

enum SearchMainSectionItem {
    case historyItem(SearchHistoryCellReactor)
    case searchItem(SearchItemCellReactor)
    case searchEmptyItem(String?)
}

//extension SearchMainSectionItem: IdentifiableType, Equatable {
//    var identity: String {
//        switch self {
//        case let .historyItem(reactor):
//            return "history_\(reactor.currentState.model)" // 또는 reactor의 id 등
//        case let .searchItem(reactor):
//            return "search_\(reactor.currentState.model.bundleID ?? "")"
//        case let .searchEmptyItem(message):
//            return "empty_\(message ?? "nil")"
//        }
//    }
//
//    static func == (lhs: SearchMainSectionItem, rhs: SearchMainSectionItem) -> Bool {
//        lhs.identity == rhs.identity
//    }
//}
