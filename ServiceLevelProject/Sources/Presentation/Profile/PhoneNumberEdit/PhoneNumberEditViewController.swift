//
//  PhoneNumberEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class PhoneNumberEditViewController: BaseViewController {
    private let phoneNumberEditView = PhoneNumberEditView()
    
    override func loadView() {
        view = phoneNumberEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        title = "연락처"
    }
}
