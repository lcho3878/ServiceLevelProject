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

// MARK: bind
extension HomeViewController {
    private func bind() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)
        
        // EmptyView - 워크스페이스 생성 버튼
        homeView.createWorkspaceButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = CreateWorkspaceViewController()
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        // 채널 바
        homeView.showChannelsButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.homeView.showChannelsButton.isSelected.toggle()
                owner.homeView.hideChannelTableView()
            }
            .disposed(by: disposeBag)
        
        // 다이렉트 메시지 바
        homeView.showDirectMessageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.homeView.showDirectMessageButton.isSelected.toggle()
                owner.homeView.hideDirectMessageTableView()
            }
            .disposed(by: disposeBag)
        
        // 채널 추가 버튼
        homeView.addChannelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.configureChannelActionSheet()
            }
            .disposed(by: disposeBag)
        
        // 팀원 추가 버튼
        homeView.addMemberButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = InviteMemberViewController()
                self.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
        
        // 새 메시지 시작 버튼
        homeView.startNewMessageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.tabBarController?.selectedIndex = 1
            }
            .disposed(by: disposeBag)
        
        // 플로팅 버튼
        homeView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.tabBarController?.selectedIndex = 1
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
}

// MARK: Functions
extension HomeViewController: NavigationRepresentable {    
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
    
    private func configureChannelActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [AddChannelActionSheet] = [.create, .search, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.channelActionSheet { action in
                switch action {
                case .create:
                    let vc = AddChannelViewController()
                    self.presentNavigationController(rootViewController: vc)
                case .search:
                    let vc = SearchChannelViewController()
                    self.presentNavigationController(rootViewController: vc)
                case .cancel:
                    print("취소")
                }
            })
        }
        
        present(actionSheet, animated: true)
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

// MARK: Enum
extension HomeViewController {
    enum AddChannelActionSheet {
        case create
        case search
        case cancel
        
        func channelActionSheet(handler: @escaping (AddChannelActionSheet) -> Void) -> UIAlertAction {
            switch self {
            case .create:
                return UIAlertAction(title: "채널 생성", style: .default) { _ in
                    handler(.create)
                }
            case .search:
                return UIAlertAction(title: "채널 탐색", style: .default) { _ in
                    handler(.search)
                }
            case .cancel:
                return UIAlertAction(title: "취소", style: .cancel) { _ in
                    handler(.cancel)
                }
            }
        }
    }
}
