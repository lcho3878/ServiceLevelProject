//
//  TabbarViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit

final class TabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
}

extension TabbarViewController {
    private func configureTabbar() {
        let viewControllers = TabbarItem.allCases.map { tabbarItem(tabbarItem: $0) }
        tabBar.tintColor = .brandBlack
        setViewControllers(viewControllers, animated: true)
    }
    
    private func tabbarItem(tabbarItem item: TabbarItem) -> UIViewController {
        let nav = UINavigationController(rootViewController: item.viewController)
        nav.tabBarItem = item.tabbarItem
        return nav
    }
    
    private enum TabbarItem: CaseIterable {
        case home
        case dm
        case search
        case setting
        
        var viewController: UIViewController {
            switch self {
            case .home: return HomeViewController()
            case .dm: return DMViewController()
            case .search: return OnboardingViewController()
            case .setting: return SettingViewController()
            }
        }
    
        private var title: String {
            switch self {
            case .home: return "홈"
            case .dm: return "DM"
            case .search: return "검색"
            case .setting: return "설정"
            }
        }
        
        private var image: UIImage {
            switch self {
            case .home: return UIImage(resource: .home)
            case .dm: return UIImage(resource: .message)
            case .search: return UIImage(resource: .profile)
            case .setting: return UIImage(resource: .setting)
            }
        }
        
        private var selectedImage: UIImage {
            switch self {
            case .home: return UIImage(resource: .homeActive)
            case .dm: return UIImage(resource: .messageActive)
            case .search: return UIImage(resource: .profileActive)
            case .setting: return UIImage(resource: .settingActive)
            }
        }
        
        var tabbarItem: UITabBarItem {
            return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        }
    }
}
