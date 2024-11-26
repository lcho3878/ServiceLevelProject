//
//  Reactive.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/26/24.
//

import UIKit
import RxSwift

extension Reactive where Base: UITextView {
    var textColor: Observable<UIColor?> {
        base.rx.observe(UIColor.self, #keyPath(UITextView.textColor))
    }
}
