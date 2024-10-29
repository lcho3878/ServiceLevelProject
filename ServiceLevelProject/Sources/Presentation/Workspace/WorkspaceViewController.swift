//
//  WorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceViewController: UIViewController {
    // MARK: Properties
    private let workspaceView = WorkspaceView()
    private let viewModel = WorkspaceViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = workspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workspaceView.workspaceEmptyView.isHidden = true // 임시
        configureTableView()
        bind()
    }
}

extension WorkspaceViewController {
    func configureTableView() {
        workspaceView.tableView.register(WorkspaceCell.self, forCellReuseIdentifier: WorkspaceCell.id)
    }
    
    func bind() {
        let input = WorkspaceViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.testData
            .bind(to: workspaceView.tableView.rx.items(cellIdentifier: WorkspaceCell.id, cellType: WorkspaceCell.self)) { (row, element, cell) in
                cell.coverImageView.image = UIImage(systemName: element.coverImage)
                cell.nameLabel.text = element.title
                cell.createdAtLabel.text = element.createdAt
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        workspaceView.tableView.rx.itemSelected
            .bind(with: self) { owner, index in
                if let selectedIndexPath = owner.workspaceView.tableView.indexPathForSelectedRow {
                    owner.workspaceView.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                
                owner.workspaceView.tableView.selectRow(at: index, animated: true, scrollPosition: .none)
            }
            .disposed(by: disposeBag)
    }
}
