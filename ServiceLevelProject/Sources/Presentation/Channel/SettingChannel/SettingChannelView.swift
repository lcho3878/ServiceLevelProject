//
//  SettingChannelView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/8/24.
//

import UIKit
import SnapKit
import Then

final class SettingChannelView: BaseView {
    var isOnwer: Bool = false {
        didSet {
            editChannelButton.isHidden = !isOnwer
            changeChannelAdminButton.isHidden = !isOnwer
            deleteChannelButton.isHidden = !isOnwer
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let channelTitleLabel = UILabel().then {
        $0.font = .title2
    }
    
    let channelDescriptionLabel = UILabel().then {
        $0.font = .body
        $0.numberOfLines = 0
    }
    
    private let showMembersBgView = UIView()
    
    let memberLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .title2
    }
    
    private let dropdownButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronRight), for: .normal)
        $0.tintColor = .brandBlack
    }
    
    lazy var showMembersButton = UIButton().then {
        $0.addTarget(self, action: #selector(dropdownButtonClicked), for: .touchUpInside)
    }
    
    let userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.register(SettingChannelCell.self, forCellWithReuseIdentifier: SettingChannelCell.id)
        $0.isScrollEnabled = false
        $0.backgroundColor = .backgroundPrimary
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .equalSpacing
    }
    
    let editChannelButton = SettingButton(title: "채널 편집", color: .brandBlack)
    let leaveChannelButton = SettingButton(title: "채널에게 나가기", color: .brandBlack)
    let changeChannelAdminButton = SettingButton(title: "채널 관리자 변경", color: .brandBlack)
    let deleteChannelButton = SettingButton(title: "채널 삭제", color: .brandError)
    
    override func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            channelTitleLabel,
            channelDescriptionLabel,
            showMembersBgView,
            userCollectionView,
            buttonStackView
        ])
        buttonStackView.addArrangedSubviews([
            editChannelButton,
            leaveChannelButton,
            changeChannelAdminButton,
            deleteChannelButton
        ])
        showMembersBgView.addSubviews([memberLabel, dropdownButton, showMembersButton])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide
        let scrollViewFrame = scrollView.frameLayoutGuide
        let scrollViewContent = scrollView.contentLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safe)
            $0.horizontalEdges.equalTo(safe)
            $0.bottom.equalTo(safe)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollViewContent.snp.verticalEdges)
            $0.horizontalEdges.equalTo(scrollViewFrame.snp.horizontalEdges)
        }
        
        channelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.horizontalEdges.equalTo(safe).inset(16)
        }
        
        channelDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(channelTitleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safe).inset(16)
        }

        showMembersBgView.snp.makeConstraints {
            $0.top.equalTo(channelDescriptionLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safe)
            $0.height.equalTo(56)
        }
        
        memberLabel.snp.makeConstraints {
            $0.leading.equalTo(showMembersBgView.snp.leading).offset(13)
            $0.verticalEdges.equalTo(showMembersBgView.snp.verticalEdges).inset(14)
        }
        
        dropdownButton.snp.makeConstraints {
            $0.trailing.equalTo(showMembersBgView.snp.trailing).offset(-16)
            $0.verticalEdges.equalTo(showMembersBgView).inset(16)
            $0.height.equalTo(24)
            $0.width.equalTo(26.79)
        }
        
        showMembersButton.snp.makeConstraints {
            $0.edges.equalTo(showMembersBgView)
        }
        
        userCollectionView.snp.makeConstraints {
            $0.top.equalTo(showMembersBgView.snp.bottom)
            $0.horizontalEdges.equalTo(safe)
            $0.height.equalTo(0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(userCollectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safe).inset(24)
            $0.bottom.equalTo(contentView).inset(24)
        }
        
        editChannelButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        leaveChannelButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        changeChannelAdminButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        deleteChannelButton.snp.makeConstraints {
            $0.height.equalTo(44)
        }
    }
    
    override func configureUI() {
        backgroundColor = .backgroundPrimary
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 14
        layout.itemSize = CGSize(width: width / 5, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}

extension SettingChannelView {
    func updateCollecionViewHeight() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            switch showMembersButton.isSelected {
            case true:
                dropdownButton.setImage(UIImage(resource: .chevronDown), for: .normal)
                userCollectionView.snp.updateConstraints {
                    $0.height.equalTo(self.userCollectionView.contentSize.height)
                }
                
            case false:
                dropdownButton.setImage(UIImage(resource: .chevronRight), for: .normal)
                userCollectionView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            }
            
            layoutIfNeeded()
        }
    }
}

extension SettingChannelView {
    class SettingButton: UIButton {
        init(title: String, color: UIColor) {
            super.init(frame: CGRect.zero)
            
            var configuration = UIButton.Configuration.bordered()
            var attributedString = AttributedString(stringLiteral: title)
            attributedString.font = UIFont.title2
            configuration.attributedTitle = attributedString
            configuration.baseForegroundColor = color
            configuration.baseBackgroundColor = .brandWhite
            configuration.background.strokeWidth = 1
            configuration.background.strokeColor = color
            configuration.background.cornerRadius = 8
            self.configuration = configuration
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension SettingChannelView {
    @objc
    private func dropdownButtonClicked() {
        showMembersButton.isSelected.toggle()
        updateCollecionViewHeight()
    }
}
