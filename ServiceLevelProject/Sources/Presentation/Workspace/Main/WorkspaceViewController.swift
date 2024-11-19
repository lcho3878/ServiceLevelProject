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

    // MARK: ViewModel Input
    let workspaceLoadTrigger = PublishSubject<Void>()
    let workspaceDeleteInput = PublishSubject<String>()
    let workspaceExitInput = PublishSubject<String>()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = workspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

// MARK: bind
extension WorkspaceViewController {
    private func bind() {
        
        let input = WorkspaceViewModel.Input(
            workspaceLoadTrigger: workspaceLoadTrigger,
            workspaceDeleteInput: workspaceDeleteInput,
            workspaceExitInput: workspaceExitInput
        )
        let output = viewModel.transform(input: input)
        
        output.workspaceList
            .bind(to: workspaceView.tableView.rx.items(cellIdentifier: WorkspaceCell.id, cellType: WorkspaceCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
                cell.editButton.rx.tap
                    .bind(with: self) { owner, _ in
                        switch element.owner_id == UserDefaultManager.userID {
                        case true:
                            owner.configureManagerActionSheet(workspace: element)
                        case false:
                            owner.configureMemberActionSheet(workspace: element)
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
        
        output.errorOutput
            .bind(with: self) { owner, errorModel in
                //E15 -> 채널관리자 오류
                owner.workspaceView.showToast(message: errorModel.errorCode, bottomOffset: -120)
            }
            .disposed(by: disposeBag)
        
        let createButtons = [workspaceView.createWorkspaceButton, workspaceView.addWorkspaceButton]
        createButtons.forEach {
            $0.rx.tap
                .bind(with: self) { owner, _ in
                    let vc = CreateWorkspaceViewController()
                    vc.delegate = owner
                    owner.presentNavigationController(rootViewController: vc)
                }
                .disposed(by: disposeBag)
        }
        
        reloadWorkspaceList()
    }
}

// MARK: Functions
extension WorkspaceViewController: NavigationRepresentable {
    func configureManagerActionSheet(workspace: WorkSpace) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [WorkspaceManagerActionSheet] = [.edit, .exit, .change, .delete, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.managerActionSheet { [weak self] action in
                switch action {
                case .edit:
                    print("워크스페이스 편집")
                    let vc = EditWorkspaceViewController()
                    vc.workspace = workspace
                    vc.delegate = self
                    self?.presentNavigationController(rootViewController: vc)
                case .exit:
                    print("워크스페이스 나가기")
                    let alert = SingleButtonAlertViewController()
                    alert.modalPresentationStyle = .overFullScreen
                    alert.setConfigure(mainTitle: "워크스페이스 나가기", subTitle: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.", buttonTitle: "확인") {}
                    self?.present(alert, animated: true)
                case .change:
                    let vc = ChangeAdminViewController()
                    self?.presentNavigationController(rootViewController: vc)
                case .delete:
                    print("워크스페이스 삭제")
                    self?.workspaceDeleteInput.onNext(workspace.workspace_id)
                case .cancel:
                    print("취소")
                }
            })
        }
        
        present(actionSheet, animated: true)
    }
    
    func configureMemberActionSheet(workspace: WorkSpace) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [WorkSpaceMemberActionSheet] = [.exit, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.memberActionSheet { [weak self] action in
                switch action {
                case .exit:
                    print("워크스페이스 나가기")
                    self?.workspaceExitInput.onNext(workspace.workspace_id)
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

extension WorkspaceViewController: WorkspaceListReloadable {
    func reloadWorkspaceList() {
        workspaceLoadTrigger.onNext(())
    }
}
