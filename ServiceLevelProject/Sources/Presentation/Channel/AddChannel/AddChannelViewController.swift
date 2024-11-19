//
//  AddChannelViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class AddChannelViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let addChannelView = AddChannelView()
    private let viewModel = AddChannelViewModel()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = addChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 생성"
    }
}

extension AddChannelViewController {
    private func bind() {
        let input = AddChannelViewModel.Input(
            channelNameText: addChannelView.channelNameTextField.rx.text.orEmpty,
            channelDescriptionText: addChannelView.channelDescriptionTextField.rx.text.orEmpty,
            createButtonTap: addChannelView.createButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
    }
}
