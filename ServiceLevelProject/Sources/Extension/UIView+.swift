//
//  UIView+.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/27/24.
//

import UIKit
import SnapKit
import Then

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
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
        }
        
        addSubview(toastView)
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
