//
//  SearchItemCell+Info.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import UIKit
import RxSwift

extension SearchItemCell {
    // MARK: - BindInfo
    func bindInfo(reactor: Reactor) {
        // MARK: - Action
        self.downloadButton.rx.tap
            .throttle(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { URLNavigatorHelper.shared.alert(title: "내 마음속에", message: "저장!") })
            .disposed(by: self.disposeBag)
        
        // MARK: - State
        reactor.state.map { $0.model.trackName }
            .distinctUntilChanged()
            .bind(to: self.searchTitleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.model.description }
            .distinctUntilChanged()
            .bind(to: self.searchDescLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.model.artworkUrl100 }
            .distinctUntilChanged()
            .compactMap { URLHelper.createEncodedURL(url: $0) }
            .bind(to: self.searchImageView.kf.rx.image())
            .disposed(by: self.disposeBag)
            
        reactor.state.map { $0.model.averageUserRating }
            .distinctUntilChanged()
            .bind(to: self.ratingView.rx.rating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.model.userRatingCount }
            .distinctUntilChanged()
            .replaceNilWith(0)
            .map { $0.shorted() }
            .bind(to: self.ratingLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
