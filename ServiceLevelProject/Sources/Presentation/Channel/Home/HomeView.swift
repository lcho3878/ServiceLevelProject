//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
    // MARK: UI
    // emptyView UI
    private let topDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    let emptyBgView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let cannotFindTitleLabel = UILabel().then {
        $0.text = "워크스페이스를 찾을 수 없어요."
        $0.font = .title1
        $0.textColor = .brandBlack
        $0.textAlignment = .center
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n새로운 워크스페이스를 생성해주세요."
        $0.font = .body
        $0.textColor = .brandBlack
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let workspaceEmptyImageView = UIImageView().then {
        $0.image = UIImage(resource: .workspaceEmpty)
        $0.contentMode = .scaleAspectFill
    }
    
    let createWorkspaceButton = BrandColorButton(title: "워크스페이스 생성")
    
    // initialView UI
    // --- 상단 채널 바 ---
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let showChannelsBgView = UIView()
    private let channelLabel = UILabel().then {
        $0.text = "채널"
        $0.textColor = .brandBlack
        $0.font = .title2
    }
    /// 이미지 표시용 버튼 - Click Action X
    let channelDropdownButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronDown), for: .normal)
        $0.tintColor = .brandBlack
    }
    /// 채널바 전체적인 클릭을 위한 버튼 - Click Action O
    let showChannelsButton = UIButton()
    
    // --- 채널 활성화 뷰 ---
    let channelBgView = UIView()
    
    let channelTableView = UITableView().then {
        $0.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.id)
        $0.rowHeight = 41
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let addChannelView = UIView()
    
    private let channelPlusImageView = UIImageView().then {
        $0.image = UIImage(resource: .plus)
        $0.tintColor = .textSecondary
    }
    
    private let addChannelLabel = UILabel().then {
        $0.text = "채널 추가"
        $0.textColor = .textSecondary
        $0.font = .body
    }
    
    let addChannelButton = UIButton()
    
    private let channelDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    // --- 다이렉트 메세지 상단바 ---
    private let showDirectMessageBgView = UIView()
    private let directMessageLabel = UILabel().then {
        $0.text = "다이렉트 메시지"
        $0.textColor = .brandBlack
        $0.font = .title2
    }
    
    /// 이미지 표시용 버튼 - Click Action X
    let directMessageDropdowmButton = UIButton().then {
        $0.setImage(UIImage(resource: .chevronDown), for: .normal)
        $0.tintColor = .brandBlack
    }
    
    /// 다이렉트 메시지바 전체적인 클릭을 위한 버튼 - Click Action O
    let showDirectMessageButton = UIButton()
    
    // --- 다이렉트 메시지 활성화 뷰 ---
    let directMessageBgView = UIView()
    
    let directMessageTableView = UITableView().then {
        $0.register(DirectMessageCell.self, forCellReuseIdentifier: DirectMessageCell.id)
        $0.rowHeight = 44
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    private let startNewMessageView = UIView()
    
    private let startNewMessagePlusImageView = UIImageView().then {
        $0.image = UIImage(resource: .plus)
        $0.tintColor = .textSecondary
    }
    
    private let startNewMessageLabel = UILabel().then {
        $0.text = "새 메시지 시작"
        $0.textColor = .textSecondary
        $0.font = .body
    }
    
    let startNewMessageButton = UIButton()
    
    private let directMessgeDividerView = UIView().then {
        $0.backgroundColor = .viewSeperator
    }
    
    // --- 팀원 추가 버튼 뷰 ---
    private let addMemberView = UIView()
    
    private let memberPlusImageView = UIImageView().then {
        $0.image = UIImage(resource: .plus)
        $0.tintColor = .textSecondary
    }
    
    private let addMemberLabel = UILabel().then {
        $0.text = "팀원 추가"
        $0.textColor = .textSecondary
        $0.font = .body
    }
    
    let addMemberButton = UIButton()
    
    // --- 하단 원형 버튼뷰 ---
    let floatingButton = UIButton().then {
        $0.backgroundColor = .brand
        $0.tintColor = .brandWhite
        $0.setImage(UIImage(resource: .floating), for: .normal)
        $0.layer.cornerRadius = 25
    }
    
    // MARK: Functions
    override func addSubviews() {
        // emptyView
        addSubviews([topDividerView, emptyBgView])
        emptyBgView.addSubviews([cannotFindTitleLabel, guideLabel, workspaceEmptyImageView, createWorkspaceButton])
        
        // initialView
        addSubviews([scrollView, floatingButton])
        scrollView.addSubview(contentView)
        contentView.addSubviews([showChannelsBgView, channelBgView, channelDividerView, showDirectMessageBgView, directMessageBgView, directMessgeDividerView, addMemberView])
        showChannelsBgView.addSubviews([channelLabel, channelDropdownButton, showChannelsButton])
        channelBgView.addSubviews([channelTableView, addChannelView])
        addChannelView.addSubviews([channelPlusImageView, addChannelLabel, addChannelButton])
        showDirectMessageBgView.addSubviews([directMessageLabel, directMessageDropdowmButton, showDirectMessageButton])
        directMessageBgView.addSubviews([directMessageTableView, startNewMessageView])
        startNewMessageView.addSubviews([startNewMessagePlusImageView, startNewMessageLabel, startNewMessageButton])
        addMemberView.addSubviews([memberPlusImageView, addMemberLabel, addMemberButton])
    }
    
    override func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        let scrollViewFrame = scrollView.frameLayoutGuide
        let scrollViewContent = scrollView.contentLayoutGuide
        
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(8)
            $0.horizontalEdges.equalTo(safeArea)
            $0.height.equalTo(1)
        }
        
        // emptyView
        emptyBgView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
        
        cannotFindTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyBgView.snp.top).offset(35)
            $0.horizontalEdges.equalTo(emptyBgView).inset(24)
            $0.height.equalTo(30)
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(cannotFindTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(emptyBgView.snp.leading).offset(23)
            $0.trailing.equalTo(emptyBgView.snp.trailing).offset(-25)
            $0.height.equalTo(40)
        }
        
        workspaceEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(15)
            $0.leading.equalTo(emptyBgView.snp.leading).offset(10)
            $0.trailing.equalTo(emptyBgView.snp.trailing).offset(-13)
            $0.height.equalTo(workspaceEmptyImageView.snp.width)
        }
        
        createWorkspaceButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-45)
            $0.horizontalEdges.equalTo(emptyBgView.snp.horizontalEdges).inset(24)
            $0.height.equalTo(44)
        }
        
        // initialView
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.horizontalEdges.equalTo(safeArea)
            $0.bottom.equalTo(safeArea)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(scrollViewContent.snp.verticalEdges)
            $0.horizontalEdges.equalTo(scrollViewFrame.snp.horizontalEdges)
        }
        
        // --- 상단 채널바 ---
        showChannelsBgView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(56)
        }
        
        channelLabel.snp.makeConstraints {
            $0.leading.equalTo(showChannelsBgView.snp.leading).offset(13)
            $0.verticalEdges.equalTo(showChannelsBgView.snp.verticalEdges).inset(14)
        }
        
        channelDropdownButton.snp.makeConstraints {
            $0.trailing.equalTo(showChannelsBgView.snp.trailing).offset(-16)
            $0.verticalEdges.equalTo(showChannelsBgView).inset(16)
            $0.height.equalTo(24)
            $0.width.equalTo(26.79)
        }
        
        showChannelsButton.snp.makeConstraints {
            $0.edges.equalTo(showChannelsBgView)
        }
        
        // --- 채널 활성화 뷰 ---
        channelBgView.snp.makeConstraints {
            $0.top.equalTo(showChannelsBgView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.bottom.equalTo(channelDividerView.snp.top).offset(-5)
        }
        
        channelTableView.snp.makeConstraints {
            $0.top.equalTo(channelBgView.snp.top)
            $0.horizontalEdges.equalTo(channelBgView.snp.horizontalEdges)
            $0.height.equalTo(0)
            $0.bottom.equalTo(addChannelView.snp.top)
        }
        
        addChannelView.snp.makeConstraints {
            $0.top.equalTo(channelTableView.snp.bottom)
            $0.horizontalEdges.equalTo(channelBgView)
            $0.height.equalTo(41)
            $0.bottom.equalTo(channelBgView.snp.bottom)
        }
        
        channelPlusImageView.snp.makeConstraints {
            $0.leading.equalTo(addChannelView.snp.leading).offset(18.25)
            $0.centerY.equalTo(addChannelView.snp.centerY)
            $0.height.width.equalTo(13.5)
        }
        
        addChannelLabel.snp.makeConstraints {
            $0.leading.equalTo(channelPlusImageView.snp.trailing).offset(18.25)
            $0.verticalEdges.equalTo(addChannelView.snp.verticalEdges)
        }
        
        addChannelButton.snp.makeConstraints {
            $0.edges.equalTo(addChannelView)
        }
        
        channelDividerView.snp.makeConstraints {
            $0.top.equalTo(addChannelView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(channelBgView)
            $0.height.equalTo(1)
        }
        
        // --- 다이렉트 메시지 바 ---
        showDirectMessageBgView.snp.makeConstraints {
            $0.top.equalTo(channelDividerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(56)
        }
        
        directMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(showDirectMessageBgView.snp.leading).offset(8)
            $0.verticalEdges.equalTo(showDirectMessageBgView).inset(14)
        }
        
        directMessageDropdowmButton.snp.makeConstraints {
            $0.trailing.equalTo(showDirectMessageBgView.snp.trailing).offset(-16)
            $0.verticalEdges.equalTo(showDirectMessageBgView).inset(16)
            $0.height.equalTo(24)
            $0.width.equalTo(26.79)
        }
        
        showDirectMessageButton.snp.makeConstraints {
            $0.edges.equalTo(showDirectMessageBgView)
        }
        
        // --- 메시지 활성화 뷰 ----
        directMessageBgView.snp.makeConstraints {
            $0.top.equalTo(showDirectMessageBgView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.bottom.equalTo(directMessgeDividerView.snp.top)
                .offset(-5)
        }
        
        directMessageTableView.snp.makeConstraints {
            $0.top.equalTo(directMessageBgView.snp.top)
            $0.horizontalEdges.equalTo(directMessageBgView)
            $0.height.equalTo(0)
            $0.bottom.equalTo(startNewMessageView.snp.top)
        }
        
        startNewMessageView.snp.makeConstraints {
            $0.top.equalTo(directMessageTableView.snp.bottom)
            $0.horizontalEdges.equalTo(directMessageBgView.snp.horizontalEdges)
            $0.height.equalTo(41)
        }
        
        startNewMessagePlusImageView.snp.makeConstraints {
            $0.leading.equalTo(startNewMessageView.snp.leading).offset(18.25)
            $0.centerY.equalTo(startNewMessageView.snp.centerY)
            $0.width.height.equalTo(13.5)
        }
        
        startNewMessageLabel.snp.makeConstraints {
            $0.leading.equalTo(startNewMessagePlusImageView.snp.trailing).offset(18.25)
            $0.verticalEdges.equalTo(startNewMessageView.snp.verticalEdges)
        }
        
        startNewMessageButton.snp.makeConstraints {
            $0.edges.equalTo(startNewMessageView)
        }
        
        directMessgeDividerView.snp.makeConstraints {
            $0.top.equalTo(startNewMessageView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(directMessageBgView)
            $0.height.equalTo(1)
        }
        
        // --- 팀원 추가 버튼 ---
        addMemberView.snp.makeConstraints {
            $0.top.equalTo(directMessgeDividerView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            $0.height.equalTo(41)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        memberPlusImageView.snp.makeConstraints {
            $0.leading.equalTo(addMemberView.snp.leading).offset(18.25)
            $0.centerY.equalTo(addMemberView.snp.centerY)
            $0.height.width.equalTo(13.5)
        }
        
        addMemberLabel.snp.makeConstraints {
            $0.leading.equalTo(memberPlusImageView.snp.trailing).offset(18.25)
            $0.verticalEdges.equalTo(addMemberView.snp.verticalEdges)
        }
        
        addMemberButton.snp.makeConstraints {
            $0.edges.equalTo(addMemberView)
        }
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalTo(safeArea).offset(-18)
            $0.bottom.equalTo(safeArea).offset(-18)
            $0.width.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        backgroundColor = .brandWhite
    }
    
    func updateChannelTableViewLayout() {
        channelTableView.snp.updateConstraints {
            $0.height.equalTo(channelTableView.contentSize.height)
        }
    }
    
    func updateDirectMessageTableViewLayout() {
        directMessageTableView.snp.updateConstraints {
            $0.height.equalTo(directMessageTableView.contentSize.height)
        }
    }
    
    func hideChannelTableView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            switch showChannelsButton.isSelected {
            case true:
                channelDropdownButton.setImage(UIImage(resource: .chevronRight), for: .normal)
                channelBgView.isHidden = true
                
                channelTableView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
                
                addChannelView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            case false:
                channelDropdownButton.setImage(UIImage(resource: .chevronDown), for: .normal)
                channelBgView.isHidden = false
                
                channelTableView.snp.updateConstraints {
                    $0.height.equalTo(self.channelTableView.contentSize.height)
                }
                
                addChannelView.snp.updateConstraints {
                    $0.height.equalTo(41)
                }
            }
            
            layoutIfNeeded()
        }
    }
    
    func hideDirectMessageTableView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            switch showDirectMessageButton.isSelected {
            case true:
                directMessageDropdowmButton.setImage(UIImage(resource: .chevronRight), for: .normal)
                directMessageBgView.isHidden = true
                
                directMessageTableView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
                
                startNewMessageView.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            case false:
                directMessageDropdowmButton.setImage(UIImage(resource: .chevronDown), for: .normal)
                directMessageBgView.isHidden = false
                
                directMessageTableView.snp.updateConstraints {
                    $0.height.equalTo(self.directMessageTableView.contentSize.height)
                }
                
                startNewMessageView.snp.updateConstraints {
                    $0.height.equalTo(41)
                }
            }
            
            layoutIfNeeded()
        }
    }
}
