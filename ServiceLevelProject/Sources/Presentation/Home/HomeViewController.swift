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
        
        configureTableView()
        bind()
        rightSwipeAction()
        homeView.emptyBgView.isHidden = true // 임시
    }
    
    override func configureNavigation() {
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = 317
        menu.presentationStyle.presentingEndAlpha = 0.7
        configureNavigaionItem()
    }
}

extension HomeViewController: NavigationRepresentable {
    private func configureTableView() {
        homeView.channelTableView.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.id)
        homeView.directMessageTableView.register(DirectMessageCell.self, forCellReuseIdentifier: DirectMessageCell.id)
    }
    
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        homeView.createWorkspaceButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CreateWorkspaceViewController()
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        homeView.showChannelsButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.homeView.showChannelsButton.isSelected.toggle()
                owner.homeView.hideChannelTableView()
            }
            .disposed(by: disposeBag)
        
        homeView.showDirectMessageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.homeView.showDirectMessageButton.isSelected.toggle()                
                owner.homeView.hideDirectMessageTableView()
            }
            .disposed(by: disposeBag)
        
        output.channelList
            .bind(to: homeView.channelTableView.rx.items(cellIdentifier: ChannelCell.id, cellType: ChannelCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.chatList
            .bind(to: homeView.directMessageTableView.rx.items(cellIdentifier: DirectMessageCell.id, cellType: DirectMessageCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        homeView.updateTableViewLayout()
    }
    
    private func configureNavigaionItem() {
        // titleView
        let homeNavigationView = HomeNavigationView()
        
        navigationItem.titleView = homeNavigationView.titleView
        
        let tapGesture = UITapGestureRecognizer()
        homeNavigationView.naviTitleLabel.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.present(owner.menu, animated: true)
            }
            .disposed(by: disposeBag)
        
        // leftBarButtonItem
        homeNavigationView.coverButton.rx.tap
            .bind(with: self) { owner, _ in
                print("coverImageClicekd")
            }
            .disposed(by: disposeBag)
        
        // rightBarButtonItem
        homeNavigationView.profileButton.rx.tap
            .bind(with: self) { owner, _ in
                print("profileImageClicked")
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = homeNavigationView.leftNaviBarItem
        navigationItem.rightBarButtonItem = homeNavigationView.rightNaviBarItem
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
