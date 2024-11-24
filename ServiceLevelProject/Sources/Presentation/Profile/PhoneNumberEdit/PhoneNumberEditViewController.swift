//
//  PhoneNumberEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneNumberEditViewController: BaseViewController {
    private let phoneNumberEditView = PhoneNumberEditView()
    private let viewModel = PhoneNumberEditViewModel()
    private let disposeBag = DisposeBag()
    weak var delegate: ChangedPhoneNumberDelegate?
    
    var currentPhoneNumber: String?
    
    override func loadView() {
        view = phoneNumberEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "연락처"
    }
}

extension PhoneNumberEditViewController {
    private func bind() {
        let input = PhoneNumberEditViewModel.Input(
            phoneNumberText: phoneNumberEditView.phoneNumberTextField.rx.text.orEmpty,
            completeButtonTap: phoneNumberEditView.confirmButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        if let currentPhoneNumber = currentPhoneNumber {
            phoneNumberEditView.phoneNumberTextField.text = currentPhoneNumber
        }
        
        // TextField 비어있는 경우 버튼 비활성화
        output.isEmptyPhoneNumber
            .bind(with: self) { owner, isEmpty in
                owner.phoneNumberEditView.isTextFieldEmpty = isEmpty
            }
            .disposed(by: disposeBag)
        
        // 변경된 연락처 전달 후 pop
        output.changedPhoneNumber
            .bind(with: self) { owner, text in
                owner.delegate?.changedPhoneNumber(data: text)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

protocol ChangedPhoneNumberDelegate: AnyObject {
    func changedPhoneNumber(data: String)
}
