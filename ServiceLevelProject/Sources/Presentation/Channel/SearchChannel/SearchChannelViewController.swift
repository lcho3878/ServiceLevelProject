//
//  SearchChannelViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchChannelViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let searchChannelView = SearchChannelView()
    private let viewModel = SearchChannelViewModel()
    private let dispoaseBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 탐색"
    }
}

extension SearchChannelViewController {
    private func bind() {
        let input = SearchChannelViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.searchChannelList
            .bind(to: searchChannelView.tableView.rx.items(cellIdentifier: SearchChannelCell.id, cellType: SearchChannelCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: dispoaseBag)
    }
}
