//
//  SearchMainViewController.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/13/24.
//

import UIKit
import ReactorKit
import RxDataSources
import ReusableKit

final class SearchMainViewController: BaseViewController {
    // MARK: - Constants
    typealias Reactor = SearchMainViewReactor
    struct Reusable {
        static let listCell = ReusableCell<SearchItemCell>()
        static let emptyCell = ReusableCell<SearchEmptyCell>()
        static let historyCell = ReusableCell<SearchHistoryCell>()
    }
    
    // MARK: - UI
    var searchBar: UISearchBar = UISearchBar().then {
        $0.placeholder = "게임, 앱, 스토리 등"
    }
    var tableView: BaseTableView = BaseTableView().then {
        $0.register(Reusable.listCell)
        $0.register(Reusable.emptyCell)
        $0.register(Reusable.historyCell)
        $0.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Initializing
    init() {
        defer { self.reactor = Reactor() }
        super.init(prefersHidden: true)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setupConstraints() {
        defer { self.loadingViewConstraints() }
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

private extension SearchMainViewController {
    // MARK: - setupUI
    func setupUI() {
        defer { self.loadingViewAddSubView() }
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }
    
    func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension SearchMainViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        self.bindSearchBar(reactor: reactor)
        self.bindTableView(reactor: reactor)
        self.bindLoading(reactor: reactor)
    }
}
