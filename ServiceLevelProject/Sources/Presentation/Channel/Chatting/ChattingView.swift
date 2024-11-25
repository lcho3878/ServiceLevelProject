//
//  ChattingView.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit
import SnapKit
import Then

final class ChattingView: BaseView {
    let chattingTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.register(ChattingTableViewCell.self, forCellReuseIdentifier: ChattingTableViewCell.id)
    }
    
    private let buttonView = UIView().then {
        $0.backgroundColor = .backgroundPrimary
        $0.layer.cornerRadius = 8
    }
    
    private let plusButton = UIButton().then {
        let image = UIImage(resource: .plusPhoto)
        $0.setImage(image, for: .normal)
    }
    
    private let chatStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fillProportionally
    }
    
    private lazy var chatTextView = UITextView().then {
        $0.font = .body
        $0.text = "메시지를 입력하세요"
        $0.textColor = .textSecondary
        $0.backgroundColor = .backgroundPrimary
        $0.textContainerInset = .zero
        $0.isScrollEnabled = false
        $0.delegate = self
    }
    
    let addImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .clear
        $0.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.id)
    }
    
    private let sendButton = UIButton().then {
        let image = UIImage(resource: .send)
        $0.setImage(image, for: .normal)
    }
    
    override func addSubviews() {
        addSubviews([chattingTableView, buttonView])
        buttonView.addSubviews([plusButton, chatStackView, sendButton])
        chatStackView.addArrangedSubviews([chatTextView, addImageCollectionView])
    }
    
    override func setConstraints() {
        let safe = safeAreaLayoutGuide

        chattingTableView.snp.makeConstraints {
            $0.top.equalTo(safe).offset(16)
            $0.horizontalEdges.equalTo(safe)
            $0.bottom.equalTo(buttonView.snp.top)
        }
        
        buttonView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(38)
            $0.horizontalEdges.equalTo(safe).inset(16)
            adjustableConstraint = $0.bottom.equalTo(safe).inset(12).constraint.layoutConstraints.first
        }
        
        plusButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(22)
            $0.bottom.equalToSuperview().inset(9)
        }
        
        chatStackView.snp.makeConstraints {
            $0.leading.equalTo(plusButton.snp.trailing).offset(8)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
            $0.verticalEdges.equalToSuperview().inset(10)
        }
        
        chatTextView.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        addImageCollectionView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        sendButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.bottom.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

extension ChattingView {
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 6
        return layout
    }
}

extension ChattingView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.textSecondary {
            textView.text = nil
            textView.textColor = UIColor.textPrimary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = UIColor.textSecondary
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 18 * 3
        let fixedWidth = textView.frame.size.width
        let sizeThatFits = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newHeight = sizeThatFits.height
        if newHeight > maxHeight {
            newHeight = maxHeight
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
        }

        textView.snp.updateConstraints {
            $0.height.equalTo(newHeight)
        }
    }
}
