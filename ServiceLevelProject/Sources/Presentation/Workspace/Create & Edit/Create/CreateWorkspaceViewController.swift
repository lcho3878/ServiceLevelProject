//
//  CreateWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import UIKit

final class CreateWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let createWorkspaceView = WorkspaceSettingView()
    weak var delegate: WorkspaceListReloadable?
    
    // MARK: View Life Cycle
    override func loadView() {
        createWorkspaceView.configureButtonTitle(title: "완료")
        view = createWorkspaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        configureAddTarget()
    }
    
    // MARK: Functions
    override func configureNavigation() {
        title = "워크스페이스 생성"
    }
}

// MARK: Button Functions
extension CreateWorkspaceViewController {
    private func configureAddTarget() {
        createWorkspaceView.createWorkspaceButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func createButtonClicked() {
        //현재는 기본 image로 워크스페이스 생성 추후에 처리해보도록 하겠습니다.
        //이미지 추가 필요
        let query = WorkspaceCreateQuery(name: createWorkspaceView.workspaceNameTextField.text!, description: createWorkspaceView.workspaceDescriptionTextField.text!, image: createWorkspaceView.workspaceImageView.image?.pngData())
        APIManager.shared.callRequest(api: WorkSpaceRouter.create(query: query), type: WorkSpace.self) { [weak self] result in
            switch result {
            case .success(let value):
                print(value)
                self?.delegate?.reloadWorkspaceList()
                self?.dismiss(animated: true)
            case .failure(let errorModel):
                self?.createWorkspaceView.showToast(message: errorModel.errorCode, bottomOffset: -120)
            }
        }
    }
}
