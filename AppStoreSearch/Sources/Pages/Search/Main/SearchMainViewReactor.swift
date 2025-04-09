//
//  SearchMainViewReactor.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/13/24.
//

import ReactorKit
import RxSwift

final class SearchMainViewReactor: Reactor {
    enum Action {
        case searchHistory(keyword: String?)
        case search(keyword: String?)
        case delete(keyword: String?)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSearching(Bool)
        case setKeyword(String?)
        case setKeywordSection([String]?)
        case setSearchMainSection(SearchResponse?)
        case setSection([SearchMainSection])
    }
    
    struct State {
        var isLoading: Bool
        var isSearching: Bool
        var keyword: String?
        var section: [SearchMainSection]
        var resultCount: Int?
    }
    
    let initialState: State
    
    init() {
        defer { _ = self.state }
        let historySection: SearchMainSection = SearchMainViewReactor.createHistorySection()
        self.initialState = State(
            isLoading: false,
            isSearching: false,
            section: [historySection]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .searchHistory(keyword):
            let trimmedKeyword: String? = keyword?.trimmed
            let setKeyword = Observable<Mutation>.just(.setKeyword(trimmedKeyword))
            let setSection = AppleSearchService.getSearchHistoryResponse(keyword: trimmedKeyword)
                .map { Mutation.setKeywordSection($0) }
            let setSearching = Observable<Mutation>.just(.setSearching(true))
            return .concat([setKeyword, setSection, setSearching])
            
        case let .search(keyword):
            let trimmedKeyword: String? = keyword?.trimmed
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            let setKeyword = Observable<Mutation>.just(.setKeyword(trimmedKeyword))
            let setSection = AppleSearchService.getSearchResponse(keyword: trimmedKeyword)
                .map { Mutation.setSearchMainSection($0?.data) }
            let setSearching = Observable<Mutation>.just(.setSearching(false))
            return .concat([startLoading, setKeyword, setSection, setSearching, endLoading])
            
        case let .delete(keyword):
            let trimmedKeyword: String? = keyword?.trimmed
            let hasChanges = AppleSearchService.deleteHistory(keyword: trimmedKeyword)
            guard hasChanges else { return .empty() }
            var setSection: Observable<Mutation> {
                if self.currentState.isSearching {
                    return AppleSearchService.getSearchHistoryResponse(keyword: trimmedKeyword)
                        .map { Mutation.setKeywordSection($0) }
                    
                } else {
                    let historySection: SearchMainSection = SearchMainViewReactor.createHistorySection()
                    return Observable<Mutation>.just(.setSection([historySection]))
                }
            }
            return .concat([setSection])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setLoading(isLoading):
            var newState = state
            newState.isLoading = isLoading
            return newState
            
        case let .setSearching(isSearching):
            var newState = state
            newState.isSearching = isSearching
            return newState
            
        case let .setKeyword(keyword):
            var newState = state
            newState.keyword = keyword
            return newState
  
        case let .setKeywordSection(response):
            var newState = state
            var section: SearchMainSection {
                if let keyword = newState.keyword,
                   keyword.isNotEmpty {
                    return SearchMainViewReactor.createSearchMainSection(response: response)
                } else {
                    return SearchMainViewReactor.createHistorySection()
                }
            }

            newState.section = [section]
            return newState

        case let .setSearchMainSection(response):
            var newState = state
            let section: SearchMainSection = SearchMainViewReactor.createResultSection(
                keyword: newState.keyword,
                response: response
            )
            newState.section = [section]
            return newState
            
        case let .setSection(section):
            var newState = state
            newState.section = section
            return newState
        }
    }
}

private extension SearchMainViewReactor {
    static func createHistorySection() -> SearchMainSection {
        let keywords = CoreDataHelper.search.action.loadKeywordHistory()
        guard keywords.count > 0 else { return SearchMainViewReactor.createEmptyHistorySection()}
        let sectionItems = keywords
            .map { SearchHistoryCellReactor(model: $0, isContains: false, isEmpty: keywords.isEmpty) }
            .compactMap { SearchMainSectionItem.historyItem($0) }
        return SearchMainSection.history(sectionItems)
    }
    
    static func createEmptyHistorySection() -> SearchMainSection {
        let cellReactor: SearchHistoryCellReactor = SearchHistoryCellReactor(
            model: "최근 검색어가 없습니다.",
            isContains: false,
            isEmpty: true
        )
        let sectionItem: SearchMainSectionItem = SearchMainSectionItem.historyItem(cellReactor)
        return SearchMainSection.history([sectionItem])
    }
    
    static func createSearchMainSection(response: [String]?) -> SearchMainSection {
        let emptyListSection: SearchMainSection = SearchMainSection.search([])
        guard let response = response,
              response.isNotEmpty else { return emptyListSection }
        let sectionItems = response
            .map { SearchHistoryCellReactor(model: $0, isContains: true) }
            .compactMap { SearchMainSectionItem.historyItem($0) }
        return SearchMainSection.search(sectionItems)
    }
    
    static func createResultSection(
        keyword: String?,
        response: SearchResponse?
    ) -> SearchMainSection {
        let emptyListSection: SearchMainSection = SearchMainSection.result([.searchEmptyItem(keyword)])
        guard let responseResults = response?.results,
              responseResults.isNotEmpty else { return emptyListSection }
        
        let sectionItems = responseResults
            .map { SearchItemCellReactor(model: $0, screenshotPrefixCount: 3) }
            .map { SearchMainSectionItem.searchItem($0) }
        
        return SearchMainSection.result(sectionItems)
    }
}
