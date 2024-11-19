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
    
    var workspaceID: String?
    // MARK: View Life Cycle
    override func loadView() {
        view = changeAdminView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "워크스페이스 관리자 변경"
    }
}

extension ChangeAdminViewController {
    private func bind() {
        let workspaceIDInput = PublishSubject<String>()
        let input = ChangeAdminViewModel.Input(workspaceIDInput: workspaceIDInput)
        let output = viewModel.transform(input: input)
        
        output.membersOutput
            .bind(to: changeAdminView.tableView.rx.items(cellIdentifier: ChangeAdminCell.id, cellType: ChangeAdminCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.emptyOutput
            .bind(with: self) { owner, _ in
                let alert = SingleButtonAlertViewController()
                alert.modalPresentationStyle = .overFullScreen
                alert.setConfigure(
                    mainTitle: "워크스페이스 관리자 변경 불가",
                    subTitle: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요.",
                    buttonTitle: "확인") {
                        //이중 코드 개선
                        owner.dismiss(animated: true) {
                            owner.dismiss(animated: true)
                        }
                    }
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        if let workspaceID { workspaceIDInput.onNext(workspaceID) }
    }
}
