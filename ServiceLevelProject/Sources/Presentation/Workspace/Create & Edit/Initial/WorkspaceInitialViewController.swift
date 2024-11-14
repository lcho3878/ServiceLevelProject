//
//  WorkspaceInitialViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/14/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WorkspaceInitialViewController: BaseViewController, RootViewTransitionable, NavigationRepresentable {
    // MARK: Properties
    private let workspaceInitialView = WorkspaceInitailView()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = workspaceInitialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAction()
    }
    
    override func configureNavigation() {
        title = "시작하기"
        navigationItem.leftBarButtonItem = leftBarButtonItem()
    }
    
    private func leftBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeMark), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                let vc = TabbarViewController()
                owner.changeRootViewController(rootVC: vc)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: Action
    private func configureAction() {
        workspaceInitialView.createWorkspaceButton.addTarget(self, action: #selector(createWorkspaceButtonClicked), for: .touchUpInside)
    }
    
    @objc func createWorkspaceButtonClicked() {
        let vc = CreateWorkspaceViewController()
        presentNavigationController(rootViewController: vc)
    }
}
