//
//  WorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceViewController: BaseViewController {
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
        bind()
    }
    
    override func configureNavigation() {
        workspaceView.tableView.register(WorkspaceCell.self, forCellReuseIdentifier: WorkspaceCell.id)
    }
}

extension WorkspaceViewController {
    func bind() {
        let input = WorkspaceViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.testData
            .bind(to: workspaceView.tableView.rx.items(cellIdentifier: WorkspaceCell.id, cellType: WorkspaceCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
                cell.editButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.configureActionSheet()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        workspaceView.tableView.rx.itemSelected
            .flatMapLatest { [weak self] indexPath -> Observable<IndexPath> in
                guard let self = self else { return .empty() }
                self.workspaceView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                
                return Observable.just(indexPath)
                    .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            }
            .bind(with: self) { owner, indexPath in
                owner.workspaceView.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editWorkspace = UIAlertAction(title: "워크스페이스 편집", style: .default) { _ in
            print("워크스페이스 편집")
        }
        
        let exitWorkspace = UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
            print("워크스페이스 나가기")
        }
        
        let changeMananger = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { _ in
            print("워크스페이스 관리자 변경")
        }
        let deleteWorkspace = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { _ in
            print("워크스페이스 삭제")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let actions: [UIAlertAction] = [editWorkspace, exitWorkspace, changeMananger, deleteWorkspace, cancel]
        actions.forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
}
