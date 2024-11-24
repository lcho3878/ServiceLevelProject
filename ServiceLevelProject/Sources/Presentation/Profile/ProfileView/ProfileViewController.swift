//
//  ProfileViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func configureNavigation() {
        title = "프로필"
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        profileView.profileTableView.delegate = self
        profileView.profileTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileContent.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.id, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        let data = ProfileContent.allCases[indexPath.row]
        cell.configureData(data)
        return cell
    }
}

extension ProfileViewController {
    enum ProfileContent: TableViewRepresentable, CaseIterable {
        case nickname
        case email
        var titleString: String {
            switch self {
            case .nickname:
                "닉네임"
            case .email:
                "이메일"
            }
        }
        var subTitleString: String {
            switch self {
            case .nickname:
                "내 브랜아입니다"
            case .email:
                "branTest3321021@gmail.com"
            }
        }
    }
}

protocol TableViewRepresentable {
    var titleString: String { get }
    var subTitleString: String { get }
}
