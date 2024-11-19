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
    var workspaceID: String? = "baec3ae9-156f-4a61-85c9-f5a9e3a350c0"
    
    // MARK: View Life Cycle
    override func loadView() {
        view = inviteMemberView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        configureAddtarget()
    }
    
    override func configureNavigation() {
        title = "팀원 초대"
    }
}

extension InviteMemberViewController {
    private func configureAddtarget() {
        inviteMemberView.inviteButton.addTarget(self, action: #selector(inviteButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func inviteButtonClicked() {
        guard let email = inviteMemberView.emailTextField.text,
        let workspaceID else { return }
        let query = WorkspaceMemberQuery(email: email)
        APIManager.shared.callRequest(api: WorkSpaceRouter.invite(id: workspaceID, query: query), type: WorkSpaceMember.self) { [weak self] result in
            switch result {
            case .success(let success):
                print(">>> success: \(success)")
            case .failure(let errorModel):
                self?.inviteMemberView.showToast(message: errorModel.errorCode, bottomOffset: -120)
            }
        }
    }
}
