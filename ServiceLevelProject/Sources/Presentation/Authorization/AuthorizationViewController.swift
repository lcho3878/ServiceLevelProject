//
//  AuthorizationViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import UIKit

class AuthorizationViewController: UIViewController {

    private let authorizationView = AuthorizationView()
    
    override func loadView() {
        view = authorizationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

