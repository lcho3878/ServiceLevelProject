//
//  ViewModelBindable.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 10/27/24.
//

import Foundation
import RxSwift

protocol ViewModelBindable {
    var disposeBag: DisposeBag { get }
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
