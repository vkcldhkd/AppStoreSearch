//
//  SearchMainViewController+TableView.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import UIKit
import RxSwift
import RxOptional
import RxDataSources

extension SearchMainViewController {
    // MARK: - BindTableView
    func bindTableView(reactor: Reactor) {
        // MARK: - DataSource
        let dataSource = self.createDataSource()
        
        // MARK: - Delegate
        self.tableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        // MARK: - Action
        self.tableView.rx.itemSelected(dataSource: dataSource)
            .throttle(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] item in
                self?.endEditing()
                
                switch item {
                case let .searchItem(cellReactor):
                    URLNavigatorHelper.shared.go(
                        name: Pages.Search.detail,
                        type: .push,
                        context: [.model: cellReactor.currentState.model]
                    )
                case let .historyItem(cellReactor):
                    guard !cellReactor.currentState.isEmpty else { return }
                    self?.reactor?.action.onNext(.search(keyword: cellReactor.currentState.model))
                    
                default: 
                    return
                }
            })
            .disposed(by: self.disposeBag)
            
        
        // MARK: - State
        reactor.state.map { $0.section }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}


//MARK: - UITableViewDelegate
extension SearchMainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let section = self.reactor?.currentState.section.first else { return nil }
        switch section {
        case .history: return SearchItemHeaderView(title: "최근 검색어")
        default: return nil
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        guard let section = self.reactor?.currentState.section.first else { return .zero }
        switch section {
        case .history: return 60
        default: return .zero
        }
    }
}

private extension SearchMainViewController {
    func createDataSource() -> RxTableViewSectionedReloadDataSource<SearchMainSection> {
        return .init(
            configureCell: { [weak self] dataSource, tableView, indexPath, sectionItem in
                guard let self = self else { return UITableViewCell() }
                guard let reactor = self.reactor else { return UITableViewCell() }
                
                switch sectionItem {
                case let .searchItem(cellReactor):
                    let cell = tableView.dequeue(Reusable.listCell, for: indexPath)
                    cell.reactor = cellReactor
                    return cell
                case let .searchEmptyItem(keyword):
                    let cell = tableView.dequeue(Reusable.emptyCell, for: indexPath)
                    cell.updateKeywordTitle(keyword: keyword)
                    return cell
                case let .historyItem(cellReactor):
                    let cell = tableView.dequeue(Reusable.historyCell, for: indexPath)
                    cell.reactor = cellReactor
                    cell.deleteButton.rx.tap
                        .throttle(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
                        .map { Reactor.Action.delete(keyword: cellReactor.currentState.model ) }
                        .bind(to: reactor.action)
                        .disposed(by: cell.disposeBag)
                    return cell
                }
            }
        )
    }
}
