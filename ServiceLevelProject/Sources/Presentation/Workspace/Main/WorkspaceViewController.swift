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
    var isManager = true

    // MARK: ViewModel Input
    let workspaceLoadTrigger = PublishSubject<Void>()
    let workspaceDeleteInput = PublishSubject<String>()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = workspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        workspaceView.workspaceEmptyView.isHidden = true // 임시
        // workspaceView.tableView.isHidden = true
        bind()
    }
}

// MARK: bind
extension WorkspaceViewController {
    func bind() {
        
        let input = WorkspaceViewModel.Input(
            workspaceLoadTrigger: workspaceLoadTrigger,
            workspaceDeleteInput: workspaceDeleteInput
        )
        let output = viewModel.transform(input: input)
        
        output.workspaceList
            .bind(to: workspaceView.tableView.rx.items(cellIdentifier: WorkspaceCell.id, cellType: WorkspaceCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
                cell.editButton.rx.tap
                    .bind(with: self) { owner, _ in
                        switch owner.isManager {
                        case true:
                            owner.configureManagerActionSheet(workspaceID: element.workspace_id)
                        case false:
                            owner.configureMemberActionSheet()
                        }
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.workspaceList
            .bind(with: self) { owner, result in
                owner.workspaceView.rx.isEmpty.onNext(result.isEmpty)
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
        
        let createButtons = [workspaceView.createWorkspaceButton, workspaceView.addWorkspaceButton]
        createButtons.forEach {
            $0.rx.tap
                .bind(with: self) { owner, _ in
                    owner.presentNavigationController(rootViewController: CreateWorkspaceViewController())
                }
                .disposed(by: disposeBag)
        }
        
        workspaceLoadTrigger.onNext(())
    }
}

// MARK: Functions
extension WorkspaceViewController: NavigationRepresentable {
    func configureManagerActionSheet(workspaceID: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [WorkspaceManagerActionSheet] = [.edit, .exit, .change, .delete, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.managerActionSheet { [weak self] action in
                switch action {
                case .edit:
                    print("워크스페이스 편집")
                    let vc = EditWorkspaceViewController()
                    self?.presentNavigationController(rootViewController: vc)
                case .exit:
                    print("워크스페이스 나가기")
                case .change:
                    let vc = ChangeAdminViewController()
                    self?.presentNavigationController(rootViewController: vc)
                case .delete:
                    print("워크스페이스 삭제")
                    self?.workspaceDeleteInput.onNext(workspaceID)
                case .cancel:
                    print("취소")
                }
            })
        }
        
        present(actionSheet, animated: true)
    }
    
    func configureMemberActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [WorkSpaceMemberActionSheet] = [.exit, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.memberActionSheet { action in
                switch action {
                case .exit:
                    print("워크스페이스 나가기")
                case .cancel:
                    print("취소")
                }
            })
        }
        
        present(actionSheet, animated: true)
    }
}
// MARK: Enum
extension WorkspaceViewController {
    enum WorkspaceManagerActionSheet {
        case edit
        case exit
        case change
        case delete
        case cancel
        
        func managerActionSheet(handler: @escaping (WorkspaceManagerActionSheet) -> Void) -> UIAlertAction {
            switch self {
            case .edit:
                return UIAlertAction(title: "워크스페이스 편집", style: .default) { _ in
                    handler(.edit)
                }
            case .exit:
                return UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
                    handler(.exit)
                }
            case .change:
                return UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { _ in
                    handler(.change)
                }
            case .delete:
                return UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { _ in
                    handler(.delete)
                }
            case .cancel:
                return UIAlertAction(title: "취소", style: .cancel) { _ in
                    handler(.cancel)
                }
            }
        }
    }
    
    enum WorkSpaceMemberActionSheet {
        case exit
        case cancel
        
        func memberActionSheet(handler: @escaping (WorkSpaceMemberActionSheet) -> Void) -> UIAlertAction {
            switch self {
            case .exit:
                return UIAlertAction(title: "워크스페이스 나가기", style: .default) { _ in
                    handler(.exit)
                }
            case .cancel:
                return UIAlertAction(title: "취소", style: .cancel) { _ in
                    handler(.cancel)
                }
            }
        }
    }
}
