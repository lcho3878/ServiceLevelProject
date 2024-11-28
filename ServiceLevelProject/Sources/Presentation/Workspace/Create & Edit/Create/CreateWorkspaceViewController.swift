//
//  CreateWorkspaceViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/2/24.
//

import UIKit
import PhotosUI

final class CreateWorkspaceViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let createWorkspaceView = WorkspaceSettingView()
    weak var delegate: WorkspaceListReloadable?
    var selectedImage: UIImage?
    
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
        
        createWorkspaceView.selectImageButton.addTarget(self, action: #selector(editImageButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func createButtonClicked() {
        guard let image = selectedImage?.asData() else { return }
        let query = WorkspaceCreateQuery(name: createWorkspaceView.workspaceNameTextField.text!, description: createWorkspaceView.workspaceDescriptionTextField.text!, image: image)
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
    
    @objc
    private func editImageButtonClicked() {
        presentPicker()
    }
}

extension CreateWorkspaceViewController {
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
                self.createWorkspaceView.workspaceImageView.image = image
            }
        }
    }
}

extension CreateWorkspaceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        if let result = results.first {
            displayImage(with: result)
        } else {
            selectedImage = nil
        }
    }
}
                                            
