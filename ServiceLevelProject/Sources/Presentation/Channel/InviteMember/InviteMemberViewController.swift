//
//  InviteMemberViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit

final class InviteMemberViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    let inviteMemberView = InviteMemberView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = inviteMemberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
    }
    
    override func configureNavigation() {
        title = "팀원 초대"
    }
}
