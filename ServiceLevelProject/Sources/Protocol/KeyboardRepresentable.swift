//
//  KeyboardRepresentable.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

@objc protocol KeyboardRepresentable: AnyObject where Self: UIView {
    var adjustableConstraint: NSLayoutConstraint? { get set }
    
    func setupKeyboardObservers()
    func removeKeyboardObservers()
    func handleKeyboardWillShow(notification: NSNotification)
    func handleKeyboardWillHide(notification: NSNotification)
}
