//
//  DoubleButtonAlertViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class DoubleButtonAlertViewController: UIViewController {
    // MARK: UI
    private let alertBgView = UIView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 16
    }
    
    private lazy var TitleLabel = UILabel().then {
        $0.text = mainTitle
        $0.font = .title2
        $0.textColor = .textPrimary
        $0.textAlignment = .center
    }
    
    private let subTitleStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = subTitle
        $0.font = .body
        $0.textColor = .textSecondary
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let subTitleBgView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var subTitle2Label = UILabel().then {
        $0.text = subTitle2
        $0.font = .body
        $0.textColor = .textSecondary
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    private let cancelButton = UIButton(type: .system).then {
        $0.setTitle("취소", for: .normal)
        $0.backgroundColor = .brandInactive
        $0.layer.cornerRadius = 8
        $0.tintColor = .brandWhite
    }
    
    private lazy var okButton = UIButton(type: .system).then {
        $0.setTitle(okButtonTitle, for: .normal)
        $0.backgroundColor = .brand
        $0.layer.cornerRadius = 8
        $0.tintColor = .brandWhite
    }
    
    // MARK: Properties
    private var mainTitle: String?
    private var subTitle: String?
    private var subTitle2: String?
    private var okButtonTitle: String?
    private var buttonAction: (() -> Void)?
    private let disposeBag = DisposeBag()
    private let customTransitionDelegate = CustomAlertTransition()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
        configureAlertUI()
        alertAction()
    }
    
    // MARK: Functions
    private func configureAlertUI() {
        // addSubview
        view.addSubview(alertBgView)
        alertBgView.addSubviews([TitleLabel, subTitleStackView, buttonStackView])
        subTitleStackView.addArrangedSubviews([subTitleLabel, subTitleBgView])
        subTitleBgView.addSubview(subTitle2Label)
        buttonStackView.addArrangedSubviews([cancelButton, okButton])
        
        // setConstraints
        let safeArea = view.safeAreaLayoutGuide
        alertBgView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.centerY.equalTo(safeArea)
            $0.top.equalTo(TitleLabel.snp.top).offset(16)
            $0.bottom.equalTo(okButton.snp.bottom).inset(-16)
        }
        
        TitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertBgView.snp.top).offset(16)
            $0.horizontalEdges.equalTo(alertBgView.snp.horizontalEdges).inset(16.5)
            $0.height.equalTo(20)
        }
        
        subTitleStackView.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(alertBgView.snp.horizontalEdges).inset(16.5)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleStackView.snp.bottom).offset(16)
            $0.bottom.equalTo(alertBgView.snp.bottom).offset(-16)
            $0.horizontalEdges.equalTo(alertBgView.snp.horizontalEdges).inset(16)
            $0.height.equalTo(44)
        }
        
        subTitle2Label.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(subTitleBgView).inset(8)
            $0.bottom.equalTo(subTitleBgView)
        }
        
        // configureUI
        view.backgroundColor = .brandBlack.withAlphaComponent(0.6)
    }
    
    func configureDelegate() {
        self.transitioningDelegate = customTransitionDelegate
    }
    
    private func alertAction() {
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.backgroundColor = .clear
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.buttonAction?()
                owner.view.backgroundColor = .clear
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setConfigure(title: String, subTitle: String, subTitle2: String? = "", buttonTitle: String, action: (() -> Void)?) {
        self.mainTitle = title
        self.subTitle = subTitle
        self.subTitle2 = subTitle2
        self.okButtonTitle = buttonTitle
        self.buttonAction = action
    }
}
