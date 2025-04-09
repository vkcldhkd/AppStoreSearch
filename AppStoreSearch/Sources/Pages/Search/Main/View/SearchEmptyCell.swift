//
//  SearchEmptyCell.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import UIKit

final class SearchEmptyCell: BaseTableViewCell {

    private lazy var containerView: UIView = UIView().then {
        $0.addSubview(self.descLabel)
        $0.addSubview(self.keywordLabel)
    }
    let descLabel: UILabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.text = "결과 없음"
        $0.textAlignment = .center
    }
    let keywordLabel: UILabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
    }
        
    //MARK: - Init
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
    }
}

extension SearchEmptyCell {
    func updateKeywordTitle(keyword: String?) {
        self.keywordLabel.text = "'\(keyword ?? "")'"
    }
}

//MARK: - UI
private extension SearchEmptyCell {
    func setupUI() {
        self.contentView.addSubview(self.containerView)
    }
    
    func setupConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        self.descLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(29)
        }
        
        self.keywordLabel.snp.makeConstraints { make in
            make.top.equalTo(self.descLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
