//
//  UIViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit
import SnapKit
import Then

extension UIViewController {
    @objc func handDismiss() {
        dismiss(animated: true)
    }
    
    // Custom ToastAlert
    func showToast(message : String, bottomOffset: Int = -20) {
        let safeArea = view.safeAreaLayoutGuide
        
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
        }
        
        view.addSubview(toastView)
        toastView.addSubview(toastLabel)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).offset(bottomOffset)
            $0.centerX.equalTo(safeArea)
            $0.width.lessThanOrEqualTo(safeArea).offset(-40)
            $0.height.equalTo(36)
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
