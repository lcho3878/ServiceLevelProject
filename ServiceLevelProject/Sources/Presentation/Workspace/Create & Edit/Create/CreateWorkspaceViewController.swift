//
//  CreateWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import UIKit

final class CreateWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    let createWorkspaceView = WorkspaceSettingView()
    
    override func loadView() {
        createWorkspaceView.configureButtonTitle(title: "완료")
        view = createWorkspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
    }
    
    override func configureNavigation() {
        title = "워크스페이스 생성"
    }
}
