//
//  EditWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import Foundation

final class EditWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    var workspace: WorkSpace?
    weak var delegate: WorkspaceListReloadable?
    private let editWorkspaceView = WorkspaceSettingView()
    
    // MARK: View Life Cycle
    override func loadView() {
        editWorkspaceView.configureButtonTitle(title: "수정")
        view = editWorkspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        configureAddTarget()
        configureTextFields()
    }
    
    // MARK: Functions
    override func configureNavigation() {
        title = "워크스페이스 편집"
    }
}

// MARK: Button Functions
extension EditWorkspaceViewController {
    private func configureAddTarget() {
        editWorkspaceView.createWorkspaceButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func createButtonClicked() {
        //현재는 기본 image로 워크스페이스 생성 추후에 처리해보도록 하겠습니다.
        //이미지 추가 필요
        guard let workspace else { return }
        let query = WorkspaceCreateQuery(name: editWorkspaceView.workspaceNameTextField.text!, description: editWorkspaceView.workspaceDescriptionTextField.text!, image: editWorkspaceView.workspaceImageView.image?.pngData())
        APIManager.shared.callRequest(api: WorkSpaceRouter.edit(id: workspace.workspace_id, query: query), type: WorkSpace.self) { [weak self] result in
            switch result {
            case .success(let value):
                print(">>> \(value)")
                self?.delegate?.reloadWorkspaceList()
                self?.dismiss(animated: true)
            case .failure(let errorModel):
                print(">>> error: \(errorModel.errorCode)")
                self?.editWorkspaceView.showToast(message: errorModel.errorCode, bottomOffset: -120)
            }
        }
    }
}

// MARK: ConfigureTextField
extension EditWorkspaceViewController {
    private func configureTextFields() {
        guard let workspace else { return }
        editWorkspaceView.workspaceNameTextField.text = workspace.name
        editWorkspaceView.workspaceDescriptionTextField.text = workspace.description
    }
}
