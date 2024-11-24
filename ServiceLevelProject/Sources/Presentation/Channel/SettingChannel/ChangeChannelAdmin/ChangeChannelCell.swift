//
//  ChangeChannelCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/24/24.
//

import UIKit
import SnapKit
import Then

final class ChangeChannelAdminCell: BaseTableViewCell {
    // MARK: UI
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .systemGray
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let userInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    let userNameLabel = UILabel().then {
        $0.font = .bodyBold
        $0.textColor = .textPrimary
        $0.textAlignment = .left
    }
    
    let userEmailLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .textSecondary
        $0.textAlignment = .left
    }
    
    
    // MARK: Functions
    override func addSubviews() {
        contentView.addSubviews([profileImageView, userInfoStackView])
        userInfoStackView.addArrangedSubviews([userNameLabel, userEmailLabel])
    }
    
    override func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea).inset(8)
            $0.leading.equalTo(safeArea).offset(14)
            $0.width.equalTo(profileImageView.snp.height)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11)
            $0.verticalEdges.equalTo(safeArea).inset(12)
            $0.trailing.equalTo(safeArea).offset(-74)
        }
    }
    
    override func configureUI() {
        selectionStyle = .none
        
        profileImageView.image = randomImage()
    }
}

extension ChangeChannelAdminCell {
    
    func configureCell(element: MemberData) {
        userNameLabel.text = element.nickname
        userEmailLabel.text = element.email
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
