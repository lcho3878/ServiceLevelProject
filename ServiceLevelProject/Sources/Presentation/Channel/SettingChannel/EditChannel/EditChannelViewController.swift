//
//  EditChannelViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/10/24.
//

import UIKit

final class EditChannelViewController: BaseViewController, DismissButtonPresentable {
    private let editChannelView = EditChannelView()
    
    override func loadView() {
        view = editChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        title = "채널 편집"
    }
}
