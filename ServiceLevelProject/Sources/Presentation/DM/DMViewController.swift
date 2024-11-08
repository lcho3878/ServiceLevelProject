//
//  DMViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DMViewController: BaseViewController {
    // MARK: Properties
    private let dmView = DMView()
    private let viewModel = DMViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = dmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        configureNavigaionItem()
    }
}

// MARK: bind
extension DMViewController {
    private func bind() {
        let input = DMViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.memberList
            .bind(to: dmView.collectionView.rx.items(cellIdentifier: DMMemberCell.id, cellType: DMMemberCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.dmList
            .bind(to: dmView.tableView.rx.items(cellIdentifier: DMListCell.id, cellType: DMListCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
    }
}

extension DMViewController {
    private func configureNavigaionItem() {
        // titleView
        let dmNavigationView = DMNavigationView()
        navigationItem.titleView = dmNavigationView.titleView
        
        // leftBarButtonItem
        dmNavigationView.coverButton.rx.tap
            .bind(with: self) { owner, _ in
                print("coverImageClicekd")
            }
            .disposed(by: disposeBag)
        
        // rightBarButtonItem
        dmNavigationView.profileButton.rx.tap
            .bind(with: self) { owner, _ in
                print("profileImageClicked")
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = dmNavigationView.leftNaviBarItem
        navigationItem.rightBarButtonItem = dmNavigationView.rightNaviBarItem
    }
}
