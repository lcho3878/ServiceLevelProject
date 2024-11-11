//
//  KeyboardDismissable.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/11/24.
//

import UIKit

protocol KeyboardDismissable: AnyObject where Self: BaseViewController { }

extension KeyboardDismissable where Self: UIViewController {
    func dismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}
