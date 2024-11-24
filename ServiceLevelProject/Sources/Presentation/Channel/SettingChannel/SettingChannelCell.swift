//
//  SettingChannelCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class SettingChannelCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "Hue"
        $0.textAlignment = .center
        $0.font = .body
    }
    
    override func addSubviews() {
        addSubviews([profileImageView, nameLabel])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(safe).offset(16.07)
            $0.centerX.equalTo(safe)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(safe)
        }
    }
    
    override func configureUI() {
        profileImageView.image = randomImage()
    }
}

extension SettingChannelCell {
    
    func configureCell(element: ChannelDetailsModel.ChannelMembers) {
        // 이미지도 넣기
        nameLabel.text = element.nickname
        Task {
            if let image = element.profileImage {
                let data = try await APIManager.shared.loadImage(image)
                profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    func randomImage() -> UIImage {
        let defaultImages: [UIImage] = [.noPhotoA, .noPhotoB, .noPhotoC]
        guard let randomImage = defaultImages.randomElement() else { return UIImage(resource: .noPhotoB)}
        return randomImage
    }
}
