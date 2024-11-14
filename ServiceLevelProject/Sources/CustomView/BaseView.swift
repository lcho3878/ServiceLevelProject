//
//  BaseView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import UIKit
import SnapKit
import Then

class BaseView: UIView, ViewRepresentable {
    
    var adjustableConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
        configureUI()
        setupKeyboardObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {}
    func setConstraints() {}
    func configureUI() {}
    
    deinit {
        removeKeyboardObservers()
    }
}

//Keyboard Observer관련
extension BaseView: KeyboardRepresentable {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        adjustableConstraint?.constant = -keyboardHeight + 24
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        adjustableConstraint?.constant = -24
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

extension BaseView {
    // Custom ToastAlert
    func showToast(message : String, bottomOffset: Int = -20) {
        let safeArea = safeAreaLayoutGuide
        
        let toastView = UIView().then {
            $0.backgroundColor = .brand
            $0.layer.cornerRadius = 8
            $0.clipsToBounds  =  true
        }
        let toastLabel = UILabel().then {
            $0.textColor = .brandWhite
            $0.font = .body
            $0.textAlignment = .center
            $0.text = message
            $0.numberOfLines = 0
        }
        
        addSubview(toastView)
        toastView.addSubview(toastLabel)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(bottomOffset)
            $0.centerX.equalTo(safeArea)
            $0.width.lessThanOrEqualTo(safeArea).offset(-40)
            $0.verticalEdges.equalTo(toastLabel.snp.verticalEdges).inset(-9)
        }
        
        toastLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(toastView.snp.verticalEdges).inset(9)
            $0.horizontalEdges.equalTo(toastView.snp.horizontalEdges).inset(16)
        }
        
        UIView.animate(
            withDuration: 3.0,
            delay: 0.5,
            options: .curveLinear,
            animations: { toastView.alpha = 0.0 }, completion: { isCompleted in
                toastView.removeFromSuperview() })
    }
}
