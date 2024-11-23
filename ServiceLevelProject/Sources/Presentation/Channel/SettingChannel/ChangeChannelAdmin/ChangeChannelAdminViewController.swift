//
//  ChangeChannelAdminViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeChannelAdminViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let changeChannelAdminView = ChangeChannelAdminView()
    private let viewModel = ChangeChannelAdminViewModel()
    private let disposeBag = DisposeBag()
    var memberData: [ChannelDetailsModel.ChannelMembers]?
    var ownerID: String?
    
    // MARK: View Life Cycle
    override func loadView() {
        view = changeChannelAdminView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 관리자 변경"
    }
}

extension ChangeChannelAdminViewController {
    private func bind() {
        let input = ChangeChannelAdminViewModel.Input(
            tableViewModelSelected: changeChannelAdminView.tableView.rx.modelSelected(MemberData.self)
        )
        let output = viewModel.transform(input: input)
        
        if let memberData = memberData, let ownerID = ownerID {
            input.memberData.onNext(memberData)
            input.ownerID.onNext(ownerID)
        }
        
        output.nonOwnerMembers
            .bind(to: changeChannelAdminView.tableView.rx.items(cellIdentifier: ChangeChannelAdminCell.id, cellType: ChangeChannelAdminCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.isOwnerOnly
            .bind(with: self) { owner, value in
                let (title, subTitle, buttonTitle) = value
                let alertVC = SingleButtonAlertViewController()
                alertVC.modalPresentationStyle = .overFullScreen
                alertVC.setConfigure(mainTitle: title, subTitle: subTitle, buttonTitle: buttonTitle) {
                    owner.dismiss(animated: true)
                }
                self.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
