//
//  UIView+.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/27/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
