//
//  UIImage+.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/25/24.
//

import UIKit

extension UIImage {
    static func randomDefaultImage() -> UIImage {
        let defaultImages: [UIImage] = [.noPhotoA, .noPhotoB, .noPhotoC]
        guard let randomImage = defaultImages.randomElement() else { return UIImage(resource: .noPhotoB)}
        return randomImage
    }
}

extension UIImage {
    func asData() -> Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
}
