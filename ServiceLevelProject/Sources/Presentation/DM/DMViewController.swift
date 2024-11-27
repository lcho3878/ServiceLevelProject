//
//  DMViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DMViewController: BaseViewController {
    // MARK: Properties
    private let dmView = DMView()
    private let viewModel = DMViewModel()
    private let disposeBag = DisposeBag()
    let dmNavigationView = DMNavigationView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = dmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupObservers()
        dmView.emptyView.isHidden = true // 임시
        // dmView.nonEmptyView.isHidden = true // 임시
    }
    
    override func configureNavigation() {
        configureNavigaionItem()
    }
}

// MARK: bind
extension DMViewController {
    private func bind() {
        let input = DMViewModel.Input(collectionViewModelSelected: dmView.collectionView.rx.modelSelected(WorkSpaceMember.self))
        let output = viewModel.transform(input: input)
        
        input.viewDidLoadTrigger.onNext(())
        
        output.memberList
            .bind(to: dmView.collectionView.rx.items(cellIdentifier: DMMemberCell.id, cellType: DMMemberCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        output.dmList
            .bind(to: dmView.tableView.rx.items(cellIdentifier: DMListCell.id, cellType: DMListCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        // 멤버 클릭 - DM 방 조회(생성)
        output.dmRoomInfo
            .bind(with: self) { owner, info in
                print(">>> info: \(info)")
            }
            .disposed(by: disposeBag)
    }
}

extension DMViewController {
    private func configureNavigaionItem() {
        // titleView
        navigationItem.titleView = dmNavigationView.titleView
        
        // leftBarButtonItem
        dmNavigationView.coverButton.rx.tap
            .bind(with: self) { owner, _ in
                print("coverImageClicekd")
            }
            .disposed(by: disposeBag)
        
        // rightBarButtonItem
        dmNavigationView.profileButton.rx.tap
            .bind(with: self) { owner, _ in
                print("profileImageClicked")
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = dmNavigationView.leftNaviBarItem
        navigationItem.rightBarButtonItem = dmNavigationView.rightNaviBarItem
    }
}

extension DMViewController {
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileImageData(_:)),
            name: .profileImageData,
            object: nil)
    }
    
    @objc
    private func profileImageData(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let profileImage = userInfo["profileData"] as? Data else { 
            print(">>> 가드 막힘")
            return }
        DispatchQueue.main.async {
            self.dmNavigationView.profileButton.setImage(UIImage(data: profileImage), for: .normal)
        }
    }
}
