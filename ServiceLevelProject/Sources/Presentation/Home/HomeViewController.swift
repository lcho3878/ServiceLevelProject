//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/27/24.
//

import UIKit
import SideMenu
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    // MARK: Properties
    private let homeView = HomeView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: UI
    let menu = SideMenuNavigationController(rootViewController: WorkspaceViewController())
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        bind()
    }
}

extension HomeViewController {
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
    }
    
    private func configureNavigation() {
        navigationItem.leftBarButtonItem = leftBarButtonItem()
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 300
    }
    
    private func leftBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = .black
        
        button.rx.tap
            .bind(with: self) { owner, _ in
                owner.present(owner.menu, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: button)
    }
}
