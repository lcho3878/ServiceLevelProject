//
//  SettingChannelViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingChannelViewController: BaseViewController {
    private let settingChannelView = SettingChannelView()
    private let disposeBag = DisposeBag()
    private let viewModel = SettingChannelViewModel()
    weak var delegate: EditInfoDelegate?
    var roomInfoData: SelectedChannelData?
    
    override func loadView() {
        view = settingChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        configureOwner()
    }
    
    override func configureNavigation() {
        title = "채널 설정"
    }
}

extension SettingChannelViewController: NavigationRepresentable {
    private func bind() {
        let input = SettingChannelViewModel.Input(
            deleteChannelButtonTap: settingChannelView.deleteChannelButton.rx.tap,
            leaveChannelButtonTap: settingChannelView.leaveChannelButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        if let roomInfoData = roomInfoData {
            input.chattingRoomInfo.onNext(roomInfoData)
            // ViewDidLoadTrigger
            input.viewDidLoadTrigger.onNext(())
        }
        
        // channelTitleLabel
        output.chattingRoomInfo
            .bind(with: self) { owner, roomInfo in
                owner.settingChannelView.channelTitleLabel.text = "#\(roomInfo.name)"
                owner.settingChannelView.channelDescriptionLabel.text = roomInfo.description
            }
            .disposed(by: disposeBag)
        
        output.channelDetail
            .bind(with: self) { owner, detail in
                owner.settingChannelView.memberLabel.text = "멤버 (\(detail.channelMembers.count))"
            }
            .disposed(by: disposeBag)
        
        // 채널 편집
        settingChannelView.editChannelButton.rx.tap
            .withLatestFrom(input.chattingRoomInfo)
            .bind(with: self) { owner, value in
                let vc = EditChannelViewController()
                vc.roomInfo = value
                vc.delegate = self
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        // 채널 관리자 여부 체크
        output.isOwner
            .bind(with: self) { owner, value in
                let (isOwner, mainTitle, subTitle, buttonTitle) = value
                switch isOwner {
                case true:
                    let alertVC = SingleButtonAlertViewController()
                    alertVC.modalPresentationStyle = .overFullScreen
                    alertVC.setConfigure(mainTitle: mainTitle, subTitle: subTitle, buttonTitle: buttonTitle) { }
                    owner.present(alertVC, animated: true)
                case false:
                    let alertVC = DoubleButtonAlertViewController()
                    alertVC.modalPresentationStyle = .overFullScreen
                    alertVC.setConfigure(title: mainTitle, subTitle: subTitle, buttonTitle: buttonTitle) {
                        // 채널 나가기 진행
                        input.exitChannel.onNext(())
                    }
                    owner.present(alertVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 삭제 메세지
        output.deleteChannelCheckAlertMessage
            .bind(with: self) { owner, message in
                let alertVC = DoubleButtonAlertViewController()
                alertVC.modalPresentationStyle = .overFullScreen
                
                alertVC.setConfigure(title: "채널 삭제", subTitle: message, buttonTitle: "삭제") {
                    input.deleteChannelAction.onNext(())
                }
                owner.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 삭제 성공 -> 화면 전환
        output.deleteSuccessNavigate
            .bind(with: self) { owner, _ in
                owner.changeRootViewController(rootVC: HomeViewController())
            }
            .disposed(by: disposeBag)
        
        // 삭제 실패 토스트
        output.deleteFailMessage
            .bind(with: self) { owner, message in
                owner.settingChannelView.showToast(message: message, bottomOffset: -120)
            }
            .disposed(by: disposeBag)
        
        // 채널 나가기 성공
        output.exitChannelSuccessful
            .bind(with: self) { owner, _ in
                let vc = TabbarViewController()
                owner.changeRootViewController(rootVC: vc)
            }
            .disposed(by: disposeBag)
        
        // 채널 관리자 변경
        settingChannelView.changeChannelAdminButton.rx.tap
            .withLatestFrom(Observable.combineLatest(output.userOutput, output.chattingRoomInfo))
            .bind(with: self) { owner, value in
                let (memberData, roomInfo) = value
                let vc = ChangeChannelAdminViewController()
                vc.delegate = self
                vc.memberData = memberData
                vc.roomInfo = roomInfo
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        // 채널 맴버 CollecionView
        output.userOutput.bind(to: settingChannelView.userCollectionView.rx.items(cellIdentifier: SettingChannelCell.id, cellType: SettingChannelCell.self)) { row, element, cell in
            cell.configureCell(element: element)
        }
        .disposed(by: disposeBag)
        
        // CollectionView 높이 업데이트
        output.userOutput
            .bind(with: self) { owner, value in
                owner.settingChannelView.updateCollecionViewHeight()
            }
            .disposed(by: disposeBag)

    }
    
    func configureOwner() {
        if let roomInfoData = roomInfoData {
            if UserDefaultManager.userID == roomInfoData.ownerID {
                settingChannelView.isOnwer = true
            } else {
                settingChannelView.isOnwer = false
            }
        }
    }
}

extension SettingChannelViewController: EditInfoDelegate {
    func editInfo(data: ChannelListModel) {
        viewModel.chattingRoomInfo.onNext(SelectedChannelData(
            name: data.name,
            description: data.description,
            channelID: data.channelID,
            ownerID: data.ownerID)
        )
        
        delegate?.editInfo(data: data)
    }
}

extension SettingChannelViewController: adminDidChangeDelegate {
    func ownerChanged(isOwner: Bool) {
        settingChannelView.isOnwer = isOwner
    }
}
