//
//  AddChannelViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddChannelViewController: BaseViewController, DismissButtonPresentable, KeyboardDismissable {
    // MARK: Properties
    private let addChannelView = AddChannelView()
    private let viewModel = AddChannelViewModel()
    private let disposeBag = DisposeBag()
    weak var delegate: UpdateChannelDelegate?
    
    // MARK: View Life Cycle
    override func loadView() {
        view = addChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        dismissKeyboardOnTap()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 생성"
    }
}

extension AddChannelViewController {
    private func bind() {
        let input = AddChannelViewModel.Input(
            channelNameText: addChannelView.channelNameTextField.rx.text.orEmpty,
            channelDescriptionText: addChannelView.channelDescriptionTextField.rx.text.orEmpty,
            createButtonTap: addChannelView.createButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        // 생성 버튼 활성화 / 비활성화
        output.isEmptyChannelNameText
            .bind(with: self) { owner, value in
                switch value {
                case true:
                    owner.addChannelView.createButton.configuration?.baseBackgroundColor = .brandInactive
                    owner.addChannelView.createButton.isEnabled = false
                case false:
                    owner.addChannelView.createButton.configuration?.baseBackgroundColor = .brand
                    owner.addChannelView.createButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
        
        // 이름 중복 toastMesaage
        output.toastMessage
            .bind(with: self) { owner, value in
                owner.dismissKeyboard()
                owner.addChannelView.showToast(message: value, bottomOffset: -120)
            }
            .disposed(by: disposeBag)
        
        // 생성 성공
        output.isCreationSuccessful
            .bind(with: self) { owner, value in
                if value {
                    owner.delegate?.updateChannelorNot(isUpdate: true)
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

protocol UpdateChannelDelegate: AnyObject {
    func updateChannelorNot(isUpdate: Bool?)
}
