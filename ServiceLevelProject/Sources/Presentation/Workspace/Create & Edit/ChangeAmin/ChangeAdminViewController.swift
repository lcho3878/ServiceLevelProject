//
//  ChangeAdminViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeAdminViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let changeAdminView = ChangeAdminView()
    private let viewModel = ChangeAdminViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: View Life Cycle
    override func loadView() {
        view = changeAdminView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        configureTableView()
        bind()
    }
    
    override func configureNavigation() {
        title = "워크스페이스 관리자 변경"
    }
}

extension ChangeAdminViewController {
    private func configureTableView() {
        changeAdminView.tableView.register(ChangeAdminCell.self, forCellReuseIdentifier: ChangeAdminCell.id)
    }
    
    private func bind() {
        let input = ChangeAdminViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.testData
            .bind(to: changeAdminView.tableView.rx.items(cellIdentifier: ChangeAdminCell.id, cellType: ChangeAdminCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
    }
}
