//
//  CoinShopViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CoinShopViewController: BaseViewController {
    private let coinshopView = CoinShopView()
    private let viewModel = CoinShopViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = coinshopView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "코인샵"
    }
}

extension CoinShopViewController {
    private func bind() {
        let input = CoinShopViewModel.Input()
        let output = viewModel.transform(input: input)
        
        input.viewDidLoadTrigger.onNext(())
        
        output.itemList
            .bind(to: coinshopView.coinTableView.rx.items(cellIdentifier: CoinTableViewCell.id, cellType: CoinTableViewCell.self)) { [weak self] (row, element, cell) in
                guard let self else { return }
                cell.configureCell(element: element)
                cell.amountButton.rx.tap
                    .bind(with: self) { owner, _ in
                        print(">>> \(element.amount)")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
