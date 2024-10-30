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
    private let menu = SideMenuNavigationController(rootViewController: WorkspaceViewController())
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        rightSwipeAction()
    }
    
    override func configureNavigation() {
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 317
        menu.presentationStyle.presentingEndAlpha = 0.7
        configureNavigaionItem()
    }
}

extension HomeViewController {
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
    }
    
    private func configureNavigaionItem() {
        // title
        let tapGesture = UITapGestureRecognizer()
        homeView.naviTitleLabel.addGestureRecognizer(tapGesture)
        navigationItem.titleView = homeView.naviTitleLabel
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.present(owner.menu, animated: true)
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
    
    private func rightSwipeAction() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: nil)
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        swipeRight.rx.event
            .bind(with: self) { owner, _ in
                owner.present(owner.menu, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
