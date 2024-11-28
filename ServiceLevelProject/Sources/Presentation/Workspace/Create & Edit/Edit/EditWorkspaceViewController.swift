//
//  EditWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import Foundation
import PhotosUI
import RxSwift
import RxCocoa

final class EditWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    var workspace: WorkSpace?
    weak var delegate: WorkspaceListReloadable?
    private let editWorkspaceView = WorkspaceSettingView()
    var selectedImage: UIImage?
    
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
        
        editWorkspaceView.editImageButton.addTarget(self, action: #selector(editImageButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func createButtonClicked() {
        guard let workspace else { return }
        guard let image = selectedImage?.asData() else { return }
        let query = WorkspaceCreateQuery(name: editWorkspaceView.workspaceNameTextField.text!, description: editWorkspaceView.workspaceDescriptionTextField.text!, image: image)
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
    
    @objc
    private func editImageButtonClicked() {
        presentPicker()
    }
}

// MARK: PHPicker
extension EditWorkspaceViewController {
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.images
        config.selectionLimit = 1
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func displayImage(with result: PHPickerResult) {
        let itemProvider = result.itemProvider
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.selectedImage = image
                self.editWorkspaceView.workspaceImageView.image = image
            }
        }
    }
}

extension EditWorkspaceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        if let result = results.first {
            displayImage(with: result)
        } else {
            selectedImage = nil
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
