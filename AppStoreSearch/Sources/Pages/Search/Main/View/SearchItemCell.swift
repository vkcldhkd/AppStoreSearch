//
//  SearchItemCell.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import UIKit
import ReactorKit
import RxKingfisher
import ReusableKit
import Cosmos

final class SearchItemCell: BaseTableViewCell {
    // MARK: - Constants
    typealias Reactor = SearchItemCellReactor
    struct Reusable {
        static let screenshotCell = ReusableCell<SearchScreenshotCell>()
    }
    
    // MARK: - UI
    let searchImageView: UIImageView = UIImageView().then {
        $0.cornerRadius = 8
    }
    private lazy var infoStackView: UIStackView = UIStackView().then {
        $0.axis = .vertical
        $0.addArrangedSubview(self.searchTitleLabel)
        $0.addArrangedSubview(self.searchDescLabel)
        $0.addArrangedSubview(self.ratingContainerView)
    }
    let searchTitleLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    let searchDescLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
    }
    lazy var ratingContainerView: UIView = UIView().then {
        $0.addSubview(self.ratingView)
        $0.addSubview(self.ratingLabel)
    }
    let ratingView: CosmosView = CosmosView().then {
        $0.isUserInteractionEnabled = false
        $0.settings.starSize = 15
        $0.settings.starMargin = 2
        $0.settings.fillMode = .half
        $0.settings.filledColor = UIColor.lightGray
        $0.settings.emptyBorderColor = UIColor.lightGray
        $0.settings.filledBorderColor = UIColor.lightGray
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    let ratingLabel: UILabel = UILabel().then {
        $0.textColor = UIColor.lightGray
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private static let downloadbuttonConfig: UIButton.Configuration = UIButton.Configuration.gray()
    let downloadButton: UIButton = UIButton(configuration: SearchItemCell.downloadbuttonConfig).then {
        $0.setTitle("받기", for: .normal)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    let collectionView: BaseCollectionView = BaseCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.register(Reusable.screenshotCell)
    }
    
    // MARK: Initializing
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
    }
}


private extension SearchItemCell {
    // MARK: - setupUI
    func setupUI() {
        self.contentView.addSubview(self.searchImageView)
        self.contentView.addSubview(self.infoStackView)
        self.contentView.addSubview(self.downloadButton)
        self.contentView.addSubview(self.collectionView)
    }
    
    // MARK: - setupConstraints
    func setupConstraints() {
        self.searchImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalTo(self.infoStackView.snp.centerY)
            make.size.equalTo(60)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.searchImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().inset(12)
        }
        
        self.searchTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        self.searchDescLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        self.ratingContainerView.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        self.ratingView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.height.equalTo(18)
        }
        
        self.ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.ratingView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(self.infoStackView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20).priority(.required)
            make.centerY.equalTo(self.infoStackView.snp.centerY)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.infoStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
            let width: CGFloat = self.contentView.frame.width
            make.height.equalTo(width * 0.7)
        }
    }
}

extension SearchItemCell: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        
        // MARK: - State
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
        
        self.bindInfo(reactor: reactor)
        self.bindCollectionView(reactor: reactor, cell: Reusable.screenshotCell)
    }
}
