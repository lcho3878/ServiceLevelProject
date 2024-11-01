//
//  SingleButtonAlertViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class SingleButtonAlertViewController: UIViewController {
    // MARK: UI
    private let alertbgView = UIView().then {
        $0.backgroundColor = .brandWhite
        $0.layer.cornerRadius = 16
    }
    
    private lazy var TitleLabel = UILabel().then {
        $0.text = mainTitle
        $0.font = .title2
        $0.textColor = .textPrimary
        $0.textAlignment = .center
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = subTitle
        $0.font = .body
        $0.textColor = .textSecondary
        $0.numberOfLines = 0
        $0.textAlignment = .center
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
        view.addSubview(alertbgView)
        alertbgView.addSubviews([TitleLabel, subTitleLabel, okButton])
        
        // setConstraints
        let safeArea = view.safeAreaLayoutGuide
        alertbgView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeArea).inset(24)
            $0.centerY.equalTo(safeArea)
            $0.top.equalTo(TitleLabel.snp.top).offset(16)
            $0.bottom.equalTo(okButton.snp.bottom).inset(-16)
        }
        
        TitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertbgView.snp.top).offset(16)
            $0.horizontalEdges.equalTo(alertbgView.snp.horizontalEdges).inset(16.5)
            $0.height.equalTo(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(alertbgView.snp.horizontalEdges).inset(16.5)
        }
        
        okButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            $0.bottom.equalTo(alertbgView.snp.bottom).offset(-16)
            $0.horizontalEdges.equalTo(alertbgView.snp.horizontalEdges).inset(16)
            $0.height.equalTo(44)
        }
        
        // configureUI
        view.backgroundColor = .brandBlack.withAlphaComponent(0.6)
    }
    
    func configureDelegate() {
        self.transitioningDelegate = customTransitionDelegate
    }
    
    private func alertAction() {
        okButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.buttonAction?()
                owner.view.backgroundColor = .clear
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setConfiure(title: String, subtitle: String, buttontTitle: String, action: (() -> Void)?) {
        self.mainTitle = title
        self.subTitle = subtitle
        self.okButtonTitle = buttontTitle
        self.buttonAction = action
    }
}
