//
//  UIStackView+.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/27/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
