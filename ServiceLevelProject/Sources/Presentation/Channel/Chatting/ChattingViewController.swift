//
//  ChattingViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

struct SelectedImage {
    let assetId: String
    let image: UIImage
}

final class ChattingViewController: BaseViewController {
    // MARK: Properties
    private let chattingView = ChattingView()
    private let disposeBag = DisposeBag()
    private let viewModel = ChattingViewModel()
    var roomInfoData: SelectedChannelData?
    
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    var selectedImages = PublishSubject<[UIImage]>()
    var selectedImageList: [UIImage] = []
    
    // MARK: View Life Cycle
    override func loadView() {
        view = chattingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        bind()
    }
    
    override func configureNavigation() {
        navigationItem.leftBarButtonItem = leftBarButtonItem()
        navigationItem.rightBarButtonItem = rightBarButtonItem()
    }
    
    deinit {
        print(">>> ChattingVC - Deinit")
    }
}

extension ChattingViewController {
    private func bind() {
        let input = ChattingViewModel.Input(
            sendMessageText: chattingView.chatTextView.rx.text.orEmpty,
            sendButtonTap: chattingView.sendButton.rx.tap,
            addImageButtonTap: chattingView.plusButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        input.viewDidLoadTrigger.onNext(())
        
        if let roomInfoData = roomInfoData {
            input.chattingRoomInfo.onNext(roomInfoData)
        }
        
        output.channelName
            .bind(with: self) { owner, value in
                owner.navigationItem.title = "# \(value)"
            }
            .disposed(by: disposeBag)
        
        output.inValidChannelMessage
            .bind(with: self) { owner, value in
                let (title, subtitle, buttonTitle) = value
                let AlertVC = SingleButtonAlertViewController()
                AlertVC.setConfigure(mainTitle: title, subTitle: subtitle, buttonTitle: buttonTitle) {
                    let vc = TabbarViewController()
                    owner.changeRootViewController(rootVC: vc)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 선택된 이미지
        selectedImages
            .bind(to: chattingView.addImageCollectionView.rx.items(cellIdentifier: AddImageCell.id, cellType: AddImageCell.self)) { (row, element, cell) in
                cell.imageView.image = element
                // 선택된 이미지 삭제
                cell.deleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.selectedImageList.removeAll(where: { $0 == element })
                        owner.selectedAssetIdentifiers.remove(at: row)
                        owner.selectedImages.onNext(owner.selectedImageList)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // TextView 비어있는 경우 보내기 버튼 비활성화
        output.isEmptyTextView
            .bind(with: self) { owner, isEmpty in
                owner.chattingView.isTextFieldEmpty = isEmpty
            }
            .disposed(by: disposeBag)
        
        // 이미지 없는 경우
        selectedImages
            .bind(with: self) { owner, imageList in
                if imageList.isEmpty {
                    owner.chattingView.addImageCollectionView.isHidden = true
                    input.isImageListEmpty.onNext(true)
                } else {
                    owner.chattingView.addImageCollectionView.isHidden = false
                    input.isImageListEmpty.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        // 사진 추가 버튼
        chattingView.plusButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
        
        output.chattingOutput
            .bind(to: chattingView.chattingTableView.rx.items(cellIdentifier: ChattingTableViewCell.id, cellType: ChattingTableViewCell.self)) { row, element, cell in
                cell.configureData(element)
            }
            .disposed(by: disposeBag)
    }
    
    private func leftBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(resource: .chevronLeft), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = TabbarViewController()
                owner.changeRootViewController(rootVC: vc)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func rightBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(resource: .homeActive), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SettingChannelViewController()
                vc.delegate = owner
                vc.roomInfoData = owner.roomInfoData
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}

extension ChattingViewController {
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 5
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func displayImage() {
        let dispatchGroup = DispatchGroup()
        
        var imagesDict = [String : UIImage]()
        var imageList: [UIImage] = []
        
        for (identifier, result) in selections {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            for identifier in self.selectedAssetIdentifiers  {
                guard let image = imagesDict[identifier] else { return }
                imageList.append(image)
                selectedImageList.removeAll()
                selectedImageList.append(contentsOf: imageList)
                selectedImages.onNext(imageList)
            }
        }
    }
}

extension ChattingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        var newSelections = [String : PHPickerResult]()
        
        for result in results {
            guard let identifier = result.assetIdentifier else { return }
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
            selectedImages.onNext([])
        } else {
            displayImage()
        }
    }
}

extension ChattingViewController: EditInfoDelegate {
    func editInfo(data: ChannelListModel) {
        viewModel.editInfo.onNext(SelectedChannelData(
            name: data.name,
            description: data.description,
            channelID: data.channelID,
            ownerID: data.ownerID)
        )
    }
}
