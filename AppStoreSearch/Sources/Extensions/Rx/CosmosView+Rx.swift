//
//  CosmosView+Rx.swift
//  AppStoreSearch
//
//  Created by HYUN SUNG on 9/14/24.
//

import Cosmos
import RxCocoa
import RxSwift

extension Reactive where Base: CosmosView {
    var rating: Binder<Double?>{
        return Binder(self.base) { view, rating in
            guard let rating = rating else { return }
            view.rating = rating
        }
    }
    
    var ratingString: Binder<String?>{
        return Binder(self.base) { view, rating in
            guard let rating = rating else { return }
            guard let ratingToDecimal = Decimal(string: rating) else { return }
            view.rating = ratingToDecimal.doubleValue
        }
    }
}
