//
//  NavigationRepresentable.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/29/24.
//

import UIKit

protocol NavigationRepresentable: AnyObject where Self: BaseViewController { }

extension NavigationRepresentable {
    func presentNavigationController(rootViewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
