//
//  UIViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit

extension UIViewController {
    @objc func handDismiss() {
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
