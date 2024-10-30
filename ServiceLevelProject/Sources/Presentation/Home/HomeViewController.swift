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

final class HomeViewController: BaseViewController {
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
        
        bind()
    }
    
    override func configureNavigation() {
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 317
        
        configureNavigaionItem()
    }
}

extension HomeViewController {
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
    }
    
    func configureNavigaionItem() {
        // title
        let tapGesture = UITapGestureRecognizer()
        homeView.naviTitleLabel.addGestureRecognizer(tapGesture)
        navigationItem.titleView = homeView.naviTitleLabel
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.present(owner.menu, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        // leftBarButtonItem
        homeView.coverButton.rx.tap
            .bind(with: self) { owner, _ in
                print("coverImageClicekd")
            }
            .disposed(by: disposeBag)
        
        // rightBarButtonItem
        homeView.profileButton.rx.tap
            .bind(with: self) { owner, _ in
                print("profileImageClicked")
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = homeView.leftNaviBarItem
        navigationItem.rightBarButtonItem = homeView.rightNaviBarItem
    }
}
