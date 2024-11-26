//
//  SearchUserViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchUserViewController: BaseViewController {
    // MARK: Properties
    private let searchUserView = SearchUserView()
    private let viewModel = SearchUserViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(">>> \(UserDefaultManager.accessToken)")
        bind()
    }
    
    override func configureNavigation() {
        navigationItem.title = "워크스페이스 멤버 탐색"
    }
}

extension SearchUserViewController: NavigationRepresentable {
    private func bind() {
        let input = SearchUserViewModel.Input(
            searchText: searchUserView.searchBar.rx.text.orEmpty,
            searchButtonClicked: searchUserView.searchBar.rx.searchButtonClicked,
            tableViewModelSelectd: searchUserView.tableView.rx.modelSelected(WorkspaceSearchUserModel.WorkspaceMembers.self)
        )
        let output = viewModel.transform(input: input)
        
        // Cancel 버튼 클릭 시, 키보드 dismiss
        searchUserView.searchBar.rx.cancelButtonClicked
            .bind(with: self) { owner, _ in
                owner.searchUserView.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        // 검색 결과
        output.searchResult
            .bind(to: searchUserView.tableView.rx.items(cellIdentifier: SearchUserCell.id, cellType: SearchUserCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        // 테이블 뷰 스크롤 시, keyboard dismiss
        searchUserView.tableView.rx.contentOffset
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // 셀 클릭
        output.targetUserID
            .bind(with: self) { owner, userID in
                let vc = ProfileViewController()
                vc.userID = userID
                owner.presentNavigationController(rootViewController: vc)
            }
            .disposed(by: disposeBag)
    }
}
