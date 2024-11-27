//
//  DMMemberCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class DMMemberCell: BaseCollectionViewCell {
    let profileImageView = UIImageView().then {
        $0.image = UIImage.randomDefaultImage()
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let userNameLabel = UILabel().then {
        $0.textColor = .textSecondary
        $0.font = .body
        $0.textAlignment = .center
    }
    
    override func addSubviews() {
        contentView.addSubviews([profileImageView, userNameLabel])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(16.07)
            $0.centerX.equalTo(safeArea)
            $0.height.width.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(safeArea).inset(14)
            $0.bottom.equalTo(safeArea).offset(-16.07)
        }
    }
    
    func configureCell(element: WorkSpaceMember) {
        Task {
            if let image = element.profileImage {
                let coverImageData = try await APIManager.shared.loadImage(image)
                profileImageView.image = UIImage(data: coverImageData)
            }
        }
        userNameLabel.text = element.nickname
    }
}
