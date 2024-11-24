//
//  NicknameEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class NicknameEditViewController: BaseViewController {
    private let nicknameEditView = NicknameEditView()
    private let viewModel = NicknameEditViewModel()
    private let disposeBag = DisposeBag()
    
    weak var delegate: ChangedNicknameDelegate?
    var currentNickname: String?
    
    override func loadView() {
        view = nicknameEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "닉네임"
    }
}

extension NicknameEditViewController {
    private func bind() {
        let input = NicknameEditViewModel.Input(
            nickNameText: nicknameEditView.nicknameTextField.rx.text.orEmpty,
            completeButtonTap: nicknameEditView.confirmButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        if let currentNickname = currentNickname {
            nicknameEditView.nicknameTextField.text = currentNickname
        }
        
        // TextField 비어있는 경우 버튼 비활성화
        output.isEmptyNickname
            .bind(with: self) { owner, isEmpty in
                owner.nicknameEditView.isTextFieldEmpty = isEmpty
            }
            .disposed(by: disposeBag)
        
        // 변경된 닉네임 전달 후 pop
        output.changedNickname
            .bind(with: self) { owner, text in
                owner.delegate?.changedNickname(data: text)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

protocol ChangedNicknameDelegate: AnyObject {
    func changedNickname(data: String)
}
