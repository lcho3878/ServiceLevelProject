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
    let viewModel = SettingChannelViewModel()
    
    override func loadView() {
        view = settingChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    override func configureNavigation() {
        title = "채널 설정"
    }
}

extension SettingChannelViewController: RootViewTransitionable {
    private func bind() {
        let input = SettingChannelViewModel.Input(deleteChannelButtonTap: settingChannelView.deleteChannelButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        settingChannelView.editChannelButton.rx.tap
            .bind(with: self) { owner, _ in
                //채널 편집 코드
            }
            .disposed(by: disposeBag)
        
        settingChannelView.leaveChannelButton.rx.tap
            .bind(with: self) { owner, _ in
                let alertVC = DoubleButtonAlertViewController()
                alertVC.modalPresentationStyle = .overFullScreen
            
                alertVC.setConfigure(title: "채널에서 나가기", subTitle: "나가기를 하면 채널 목록에서 삭제됩니다.", buttonTitle: "나가기") {
                    //채널 나가기 로직
                }
                owner.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        settingChannelView.changeChannelAdminButton.rx.tap
            .bind(with: self) { owner, _ in
                //채널 관리자 변경 코드
            }
            .disposed(by: disposeBag)
        
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
        
        output.deleteSuccessNavigate
            .bind(with: self) { owner, _ in
                owner.changeRootViewController(rootVC: HomeViewController())
            }
            .disposed(by: disposeBag)
        
        output.deleteFailMessage
            .bind(with: self) { owner, message in
                owner.settingChannelView.showToast(message: message, bottomOffset: -120)
            }
            .disposed(by: disposeBag)
        
        output.userOutput.bind(to: settingChannelView.userCollectionView.rx.items(cellIdentifier: SettingChannelCell.id, cellType: SettingChannelCell.self)) { row, element, cell in
            //cell configureUI 추가
        }
        .disposed(by: disposeBag)
        
        settingChannelView.updateCollectionViewLayout()
    }
}
