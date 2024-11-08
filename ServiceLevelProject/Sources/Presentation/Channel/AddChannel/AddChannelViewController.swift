//
//  AddChannelViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit

final class AddChannelViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    let addChannelView = AddChannelView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = addChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
    }
    
    override func configureNavigation() {
        title = "채널 생성"
    }
}
