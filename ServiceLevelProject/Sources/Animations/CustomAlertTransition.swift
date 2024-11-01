//
//  CustomAlertTransition.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/1/24.
//

import UIKit

/// CutomAlert 화면 전환을 위한 클래스
/*
 <사용법 예시>
 @objc func testButtonTapped() {
     let alertVC = SingleButtonAlertViewController()
     alertVC.modalPresentationStyle = .overFullScreen
     
     alertVC.setConfiure(
         title: "메인타이틀",
         subtitle: "서브타이틀",
         buttontTitle: "버튼타이틀") {
             print("클릭 시, action")
         }
     
     self.present(alertVC, animated: true)
 }
 */
final class CustomAlertTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var isPresenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to)  else { return }
        let containerView = transitionContext.containerView
        
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
            toViewController.view.transform = CGAffineTransform.identity
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
    
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { finished in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresenting ? animatePresentation(using: transitionContext) : animateDismissal(using: transitionContext)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
