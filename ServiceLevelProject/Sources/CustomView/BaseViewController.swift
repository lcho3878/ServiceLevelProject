//
//  BaseViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/28/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBackButton()
        configureNavigation()
    }
    
    func configureNavigation() {}
    private func hideNavigationBackButton() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .brandBlack
    }
}
