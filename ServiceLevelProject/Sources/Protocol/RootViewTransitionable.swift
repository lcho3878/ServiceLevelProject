//
//  RootViewTransitionable.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/14/24.
//

import UIKit

/// 루트 뷰 컨트롤러 전환이 가능한 뷰 컨트롤러를 식별하는 프로토콜입니다.
///
/// `RootViewTransitionable`을 준수하는 뷰 컨트롤러는 앱의 루트 뷰 컨트롤러를 전환할 수 있습니다.
///
/// 사용법:
/// 이 프로토콜을 준수하는 뷰 컨트롤러에 `changeRootViewController(rootVC:isNavigation:)` 메서드를 사용하여
/// 루트 뷰 컨트롤러를 전환합니다.
protocol RootViewTransitionable: AnyObject where Self: UIViewController { }

extension RootViewTransitionable {
    /// 지정된 뷰 컨트롤러로 루트 뷰 컨트롤러를 변경하며, 필요 시 애니메이션을 추가합니다.
    ///
    /// - Parameters:
    ///   - viewController: 새로운 루트 뷰 컨트롤러.
    ///   - isNavigation: 새로운 루트 뷰컨트롤러가 UINavigationController에 포함되어 있다면 true로 사용합니다. 기본값은 false입니다.
    func changeRootViewController(rootVC: UIViewController, isNavigation: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let window = windowScene.windows.first else { return }
        let vc: UIViewController
        if isNavigation {
            let nav = UINavigationController(rootViewController: rootVC)
            vc = nav
        } else {
            vc = rootVC
        }
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
