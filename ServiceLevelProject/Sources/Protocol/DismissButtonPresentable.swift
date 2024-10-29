//
//  DismissButtonPresentable.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit

protocol DismissButtonPresentable: AnyObject where Self: BaseViewController { }

extension DismissButtonPresentable {
    func setDismissButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(resource: .closeMark), style: .plain, target: self, action: #selector(UIViewController.handDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }
}
