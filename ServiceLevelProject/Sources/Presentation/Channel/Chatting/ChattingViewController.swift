//
//  ChattingViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingViewController: BaseViewController {
    // MARK: Properties
    private let chattingView = ChattingView()
    private let disposeBag = DisposeBag()
    private let viewModel = ChattingViewModel()
    var roomInfoData: SelectedChannelData?
    
    // MARK: View Life Cycle
    override func loadView() {
        view = chattingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        bind()
    }
    
    override func configureNavigation() {
        navigationItem.leftBarButtonItem = leftBarButtonItem()
        navigationItem.rightBarButtonItem = rightBarButtonItem()
    }
}

extension ChattingViewController {
    private func bind() {
        let input = ChattingViewModel.Input()
        let output = viewModel.transform(input: input)
        
        input.viewDidLoadTrigger.onNext(())
        
        if let roomInfoData = roomInfoData {
            input.chattingRoomInfo.onNext(roomInfoData)
        }
        
        output.channelName
            .bind(with: self) { owner, value in
                owner.navigationItem.title = "# \(value)"
            }
            .disposed(by: disposeBag)
        
        output.inValidChannelMessage
            .bind(with: self) { owner, value in
                let (title, subtitle, buttonTitle) = value
                let AlertVC = SingleButtonAlertViewController()
                AlertVC.setConfigure(mainTitle: title, subTitle: subtitle, buttonTitle: buttonTitle) {
                    let vc = TabbarViewController()
                    owner.changeRootViewController(rootVC: vc)
                }
            }
            .disposed(by: disposeBag)
        
        output.chattingOutput
            .bind(to: chattingView.chattingTableView.rx.items(cellIdentifier: ChattingTableViewCell.id, cellType: ChattingTableViewCell.self)) { row, element, cell in
                cell.configureData(element)
            }
            .disposed(by: disposeBag)
    }
    
    private func leftBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(resource: .chevronLeft), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = TabbarViewController()
                owner.changeRootViewController(rootVC: vc)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(resource: .homeActive), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SettingChannelViewController()
                vc.delegate = owner
                vc.roomInfoData = owner.roomInfoData
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}

extension ChattingViewController: EditInfoDelegate {
    func editInfo(data: ChannelListModel) {
        viewModel.editInfo.onNext(SelectedChannelData(
            name: data.name,
            description: data.description,
            channelID: data.channelID,
            ownerID: data.ownerID)
        )
    }
}
