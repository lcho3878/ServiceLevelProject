//
//  ProfileEditViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/1/24.
//

import UIKit

final class ProfileEditViewController: BaseViewController {
    private let profileEditView = ProfileEditView()
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func configureNavigation() {
        title = "내 정보 수정"
    }
}

extension ProfileEditViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        profileEditView.profileMenuTableView.delegate = self
        profileEditView.profileMenuTableView.dataSource = self
        profileEditView.profileMenuTableView2.delegate = self
        profileEditView.profileMenuTableView2.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileEditView.profileMenuTableView {
            return TableViewMenus.allCases.count
        }
        else {
            return TableViewMenus2.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableViewCell.id, for: indexPath) as? ProfileEditTableViewCell else {
            return UITableViewCell() }
        let row = indexPath.row
        if tableView == profileEditView.profileMenuTableView {
            let data = TableViewMenus.allCases[row]
            cell.configureData(data)
        }
        else {
            let data = TableViewMenus2.allCases[row]
            cell.configureData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profileEditView.profileMenuTableView2 && TableViewMenus2.allCases[indexPath.row] == .logout {
            let alert = DoubleButtonAlertViewController()
            alert.modalPresentationStyle = .overFullScreen
            alert.setConfigure(title: "로그아웃", subTitle: "정말 로그아웃 할까요?", buttonTitle: "로그아웃") { [weak self] in
                UserDefaultManager.removeUserData()
                self?.changeRootViewController(rootVC: OnboardingViewController())
            }
            present(alert, animated: true)
        }
    }
}

extension ProfileEditViewController {
    enum TableViewMenus: CaseIterable, TableViewRepresentable {
        case mycoin
        case nickname
        case contact
        
        var titleString: String {
            switch self {
            case .mycoin:
                "내 새싹 코인"
            case .nickname:
                "닉네임"
            case .contact:
                "연락처"
            }
        }
        
        var subTitleString: String {
            switch self {
            case .mycoin:
                "충전하기"
            case .nickname:
                "옹골찬 고래밥"
            case .contact:
                "010-1234-1234"
            }
        }
    }
    
    enum TableViewMenus2: CaseIterable, TableViewRepresentable {
        case email
        case socials
        case logout
        
        var titleString: String {
            switch self {
            case .email:
                "이메일"
            case .socials:
                "연결된 소셜 계정"
            case .logout:
                "로그아웃"
            }
        }
         
        var subTitleString: String {
            switch self {
            case .email:
                "sesac@sesac.com"
            case .socials:
                ""
            case .logout:
                ""
            }
        }
    }
}


