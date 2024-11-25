//
//  ChattingTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChattingTableViewCell: BaseTableViewCell {
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let centerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .caption
        $0.textColor = .textPrimary
    }
    
    private let messageLabel = PaddingLabel().then {
        $0.font = .body
        $0.textColor = .textPrimary
        $0.layer.borderColor = UIColor.viewSeperator.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 12
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "08:16 오전"
        $0.font = .caption
        $0.textColor = .textSecondary
    }
    
    private let imageStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 2
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let firstImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    private let secondImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
    }
    
    override func addSubviews() {
        imageStackView.addArrangedSubviews([
            firstImageStackView,
            secondImageStackView
        ])
        
        centerStackView.addArrangedSubviews([
            messageLabel,
            imageStackView
        ])
        addSubviews([
            profileImageView,
            nicknameLabel,
            centerStackView,
            dateLabel,
        ])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(6)
            $0.leading.equalTo(safe).offset(16)
            $0.size.equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        centerStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalTo(safe).inset(6)
        }
        
        imageStackView.snp.makeConstraints {
            $0.width.equalTo(244)
        }
        
        firstImageStackView.snp.makeConstraints { $0.height.equalTo(80) }
        secondImageStackView.snp.makeConstraints { $0.height.equalTo(80) }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(centerStackView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(safe).inset(20)
            $0.bottom.equalTo(centerStackView)
        }
    }
}

extension ChattingTableViewCell {
    typealias Chatting = ChannelChatHistoryModel
    
    func configureData(_ data: Chatting) {
        nicknameLabel.text = data.user.nickname
        Task { [weak self] in
            let data = try await APIManager.shared.loadImage(data.user.profileImage)
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: data)
            }
        }
        messageLabel.text = data.content
        messageLabel.isHidden = data.content.isEmpty
        imageStackView.isHidden = true
        if !data.files.isEmpty {
            configureImages(files: data.files)
        } else {
            imageStackView.isHidden = true
            firstImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            secondImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        
    }
    
    private func configureImages(files: [String]) {
        imageStackView.isHidden = files.isEmpty
        firstImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        secondImageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let imageViews = files.map { file -> UIImageView in
            let imageView = UIImageView()
            Task {
                let data = try await APIManager.shared.loadImage(file)
                let image = UIImage(data: data)
                imageView.image = image
            }
            imageView.backgroundColor = .lightGray
            imageView.layer.cornerRadius = 8
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }
        
        let count = files.count
        switch count {
        case 1:
            if let imageView = imageViews.first {
                firstImageStackView.addArrangedSubview(imageView)
            }
            firstImageStackView.snp.remakeConstraints { $0.height.equalTo(160) }
            secondImageStackView.isHidden = true
            
        case 2:
            for imageView in imageViews {
                firstImageStackView.addArrangedSubview(imageView)
            }
            firstImageStackView.snp.remakeConstraints { $0.height.equalTo(80) }
            secondImageStackView.isHidden = true
            
        case 3:
            for imageView in imageViews {
                firstImageStackView.addArrangedSubview(imageView)
            }
            firstImageStackView.snp.remakeConstraints { $0.height.equalTo(80) }
            secondImageStackView.isHidden = true
            
        case 4:
            for (index, imageView) in imageViews.enumerated() {
                if index < 2 {
                    firstImageStackView.addArrangedSubview(imageView)
                } else {
                    secondImageStackView.addArrangedSubview(imageView)
                }
            }
            firstImageStackView.snp.remakeConstraints { $0.height.equalTo(80) }
            secondImageStackView.isHidden = false
        case 5:
            for (index, imageView) in imageViews.enumerated() {
                if index < 3 {
                    firstImageStackView.addArrangedSubview(imageView)
                } else {
                    secondImageStackView.addArrangedSubview(imageView)
                }
            }
            firstImageStackView.snp.remakeConstraints { $0.height.equalTo(80) }
            secondImageStackView.isHidden = false
        default:
            break
        }
        layoutIfNeeded()
    }
}
