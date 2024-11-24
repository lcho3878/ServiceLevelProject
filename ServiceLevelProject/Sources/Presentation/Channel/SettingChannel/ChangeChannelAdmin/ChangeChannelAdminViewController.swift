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
    weak var delegate: adminDidChangeDelegate?
    var memberData: [ChannelDetailsModel.ChannelMembers]?
    var roomInfo: SelectedChannelData?
    
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
        
        if let memberData = memberData, let ownerID = roomInfo?.ownerID, let channelID = roomInfo?.channelID {
            input.memberData.onNext(memberData)
            input.ownerID.onNext(ownerID)
            input.channelID.onNext(channelID)
        }
        
        // Owner를 제외한 멤버수
        output.nonOwnerMembers
            .bind(to: changeChannelAdminView.tableView.rx.items(cellIdentifier: ChangeChannelAdminCell.id, cellType: ChangeChannelAdminCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        // Owner만 있는 경우
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
        
        // 채널 관리자 변경 Alert
        output.changeAdminAlert
            .bind(with: self) { owner, value in
                let (title, subtitle, subtitle2, buttontitle) = value
                let alertVC = DoubleButtonAlertViewController()
                alertVC.modalPresentationStyle = .overFullScreen
                alertVC.setConfigure(title: title, subTitle: subtitle, subTitle2: subtitle2, buttonTitle: buttontitle) {
                    input.proceedChangeAdmin.onNext(())
                }
                self.present(alertVC, animated: true)
             }
            .disposed(by: disposeBag)
        
        // 채널 관리자 변경 성공
        output.changeAdminSuccessful
            .bind(with: self) { owner, _ in
                owner.delegate?.ownerChanged(isOwner: false)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

protocol adminDidChangeDelegate: AnyObject {
    func ownerChanged(isOwner: Bool)
}
