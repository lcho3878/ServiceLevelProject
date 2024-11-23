//
//  EditChannelViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditChannelViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Propereties
    private let editChannelView = EditChannelView()
    private let viewModel = EditChannelViewModel()
    private let disposeBag = DisposeBag()
    weak var delegate: EditInfoDelegate?
    var roomInfo: SearchChannelViewModel.selectedChannelData?
    
    override func loadView() {
        view = editChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 편집"
    }
}

extension EditChannelViewController {
    private func bind() {
        let input = EditChannelViewModel.Input(
            channelNameText: editChannelView.channelNameTextField.rx.text.orEmpty,
            channelDescriptionText: editChannelView.channelDescriptionTextField.rx.text.orEmpty,
            completeButtonTap: editChannelView.completeButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        if let roomInfo = roomInfo {
            input.roomInfo.onNext(roomInfo)
        }
        
        output.roomInfo
            .bind(with: self) { owner, roomInfo in
                owner.editChannelView.channelNameTextField.text = roomInfo.name
                owner.editChannelView.channelDescriptionTextField.text = roomInfo.description
            }
            .disposed(by: disposeBag)
        
        output.editSuccessful
            .bind(with: self) { owner, value in
                owner.delegate?.editInfo(data: value)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

protocol EditInfoDelegate: AnyObject {
    func editInfo(data: ChannelListModel)
}
