//
//  CoinShopViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinShopViewModel: ViewModelBindable {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let itemList: PublishSubject<[CoinShopItemListModel]>
    }
    
    func transform(input: Input) -> Output {
        let itemList = PublishSubject<[CoinShopItemListModel]>()
        
        input.viewDidLoadTrigger
            .flatMap { _ in
                return APIManager.shared.callRequest(api: CoinShopRouter.itemList, type: [CoinShopItemListModel].self)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    itemList.onNext(success)
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(itemList: itemList)
    }
}
