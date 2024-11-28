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
    private let homeNavigationView = HomeNavigationView()
    private let disposeBag = DisposeBag()
    private var isUpdateChannel = false
    private let workspaceIDInput = PublishSubject<String>()
    private var menu: SideMenuNavigationController?
    private var popFromEditView = false
    private let dmReloadTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        rightSwipeAction()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureViewWillAppear()
    }
    
    override func configureNavigation() {
        let vc = WorkspaceViewController()
        vc.delegate = self
        menu = SideMenuNavigationController(rootViewController: vc)
        guard let menu else { return }
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
        let input = HomeViewModel.Input(
            workspaceID: workspaceIDInput,
            channelTableViewModelSelected: homeView.channelTableView.rx.modelSelected(ChannelList.self),
            dmReloadTrigger: dmReloadTrigger
        )
        let output = viewModel.transform(input: input)
        
        output.hasWorkspace
            .bind(with: self) { owner, value in
                owner.homeView.hasWorkspace = value
                owner.tabBarController?.tabBar.isHidden = !value
            }
            .disposed(by: disposeBag)
        
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
            .withLatestFrom(input.myChannelIdList)
            .bind(with: self) { owner, IdList in
                let createVC = AddChannelViewController()
                createVC.delegate = owner
                
                let searchVC = SearchChannelViewController()
                searchVC.viewModel.myChannelIdList.onNext(IdList)
                owner.configureChannelActionSheet(createVC: createVC, searchVC: searchVC)
            }
            .disposed(by: disposeBag)
        
        // 팀원 추가 버튼
        homeView.addMemberButton.rx.tap
            .withLatestFrom(output.workspaceOutput)
            .bind(with: self) { owner, workspace in
                guard UserDefaultManager.userID == workspace.owner_id else {
                    owner.homeView.showToast(message: "워크스페이스 관리자만 팀원을 초대할 수 있어요. 관리자에게 요청을 해보세요.", bottomOffset: -120)
                    return
                }
                let vc = InviteMemberViewController()
                owner.presentNavigationController(rootViewController: vc)
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
        
        // 채널 클릭
        output.goToMyChannel
            .bind(with: self) { owner, selectedData in
                // 채팅뷰로 바로 이동
                let vc = ChattingViewController()
                vc.roomInfoData = selectedData
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 네비게이션뷰 UI 업데이트
        /// 채널 커버 이미지
        output.workspaceOutput
            .bind(with: self) { owner, value in
                owner.homeNavigationView.updateUI(value)
            }
            .disposed(by: disposeBag)
        
        // 채널 리스트
        output.channelList
            .bind(to: homeView.channelTableView.rx.items(cellIdentifier: ChannelCell.id, cellType: ChannelCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
                self.homeView.updateChannelTableViewLayout()
            }
            .disposed(by: disposeBag)
        
        // 다이렉트 메시지 output empty 분기처리
        output.dmList
            .bind(with: self) { owner, dmList in
                owner.homeView.updateDirectMessageTableViewLayout(dmList.count)
            }
            .disposed(by: disposeBag)
        
        // 다이렉트 메시지 리스트
        output.dmList
            .bind(to: homeView.directMessageTableView.rx.items(cellIdentifier: DirectMessageCell.id, cellType: DirectMessageCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
                self.homeView.updateDirectMessageTableViewLayout()
            }
            .disposed(by: disposeBag)
        
        // dm 클릭
        homeView.directMessageTableView.rx.modelSelected(DMList.self)
            .bind(with: self) { owner, dmList in
                let vc = ChattingViewController()
                vc.roomInfoData = dmList.selectedChannelData
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        homeView.updateTableViewLayout()
        
        // viewDidLoadTrigger
        viewModel.viewDidLoadTrigger.onNext(())
    }
}

// MARK: Functions
extension HomeViewController: NavigationRepresentable {    
    private func configureNavigaionItem() {
        
        navigationItem.titleView = homeNavigationView.titleView
        
        let tapGesture = UITapGestureRecognizer()
        homeNavigationView.naviTitleLabel.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                guard let menu = owner.menu else { return }
                owner.present(menu, animated: true)
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
                let vc = ProfileEditViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.didPopDelegate = owner
                vc.delegate = owner
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = homeNavigationView.leftNaviBarItem
        navigationItem.rightBarButtonItem = homeNavigationView.rightNaviBarItem
    }
    
    private func configureChannelActionSheet(createVC: UIViewController, searchVC: UIViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [AddChannelActionSheet] = [.create, .search, .cancel]
        actions.forEach { action in
            actionSheet.addAction(action.channelActionSheet { action in
                switch action {
                case .create:
                    self.presentNavigationController(rootViewController: createVC)
                case .search:
                    self.presentNavigationController(rootViewController: searchVC)
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
                guard let menu = owner.menu else { return }
                owner.present(menu, animated: true)
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

extension HomeViewController{
    private func configureViewWillAppear() {
        if isUpdateChannel {
            viewModel.isUpdateChannelList.onNext(true)
            isUpdateChannel = false
        }
        
        viewModel.popFromEditView
            .bind(with: self) { owner, value in
                if value {
                    owner.viewModel.viewDidLoadTrigger.onNext(())
                    owner.popFromEditView = false
                }
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UpdateChannelDelegate {
    func updateChannelorNot(isUpdate: Bool?) {
        guard let isUpdate = isUpdate else { return }
        isUpdateChannel = isUpdate
    }
}

extension HomeViewController: WorkspaceChangable {
    func workspaceChange(_ workspace: WorkSpace) {
        UserDefaultManager.workspaceID = workspace.workspace_id
        workspaceIDInput.onNext(workspace.workspace_id)
        homeNavigationView.updateUI(workspace)
    }
}

extension HomeViewController: ChangedProfileImageDelegate {
    func changedImageData(imageData: Data) {
        DispatchQueue.main.async {
            self.homeNavigationView.profileButton.setImage(UIImage(data: imageData), for: .normal)
        }
    }
}

extension HomeViewController: PopFromEditProfileViewDelegate {
    func popFromEdit(fromProfileView: Bool) {
        viewModel.popFromEditView.onNext(fromProfileView)
    }
}

extension HomeViewController {
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeAdminRecieved),
            name: Notification.Name(NotificationKey.changeAdmin.rawValue),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileImageData(_:)),
            name: .profileImageData,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editedWorkspaceData(_:)),
            name: .editedWorkspaceData,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDMList(_:)),
            name: .dmListUpdate,
            object: nil
        )
    }
    
    @objc
    private func changeAdminRecieved(_ notification: Notification) {
        if let userinfo = notification.userInfo,
           let message = userinfo[NotificationKey.toastMessage] as? String {
            homeView.showToast(message: message, bottomOffset: -120)
        }
    }
    
    @objc
    private func profileImageData(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let profileImage = userInfo["profileData"] as? Data else { return }
        DispatchQueue.main.async {
            self.homeNavigationView.profileButton.setImage(UIImage(data: profileImage), for: .normal)
        }
    }
    
    @objc
    private func editedWorkspaceData(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let editedData = userInfo["editedData"] as? WorkSpace else { return }
        
        Task {
            let coverImageData = try await APIManager.shared.loadImage(editedData.coverImage)
            homeNavigationView.coverButton.setImage(UIImage(data: coverImageData), for: .normal)
        }
        
        homeNavigationView.naviTitleLabel.text = editedData.name
    }
    
    @objc
    private func updateDMList(_ notification: Notification) {
        dmReloadTrigger.onNext(())
    }
}
