//
//  EditWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import Foundation

final class EditWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    let editWorkspaceView = WorkspaceSettingView()
    
    
    // MARK: View Life Cycle
    override func loadView() {
        editWorkspaceView.configureButtonTitle(title: "수정")
        view = editWorkspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
    }
    
    // MARK: Functions
    override func configureNavigation() {
        title = "워크스페이스 편집"
    }
}
