//
//  SettingViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {
    // MARK: Properties
    let settingView = SettingView()
    let viewModel = SettingViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureNavigation() {
        title = "설정"
    }
}

extension SettingViewController {
    private func bind() {
        let input = SettingViewModel.Input()
        let output = viewModel.transform(input: input)
        
        input.settingList
            .bind(to: settingView.tableView.rx.items(cellIdentifier: SettingCell.id, cellType: SettingCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
            }
            .disposed(by: disposeBag)
        
        settingView.tableView.rx.modelSelected(SettingViewModel.SettingModel.self)
            .compactMap { CellTitle(rawValue: $0.title) }
            .bind(with: self) { owner, cellTitle in
                switch cellTitle {
                case .editProfile:
                    owner.editProfile()
                case .logout:
                    owner.logoutAlert()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SettingViewController {
    enum CellTitle: String {
        case editProfile = "내 정보 수정"
        case logout = "로그아웃"
    }
    
    private func editProfile() {
        let vc = ProfileEditViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logoutAlert() {
        let alert = DoubleButtonAlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.setConfigure(title: "로그아웃", subTitle: "정말 로그아웃 할까요?", buttonTitle: "로그아웃") { [weak self] in
            UserDefaultManager.removeUserData()
            self?.changeRootViewController(rootVC: OnboardingViewController())
        }
        present(alert, animated: true)
    }
}
