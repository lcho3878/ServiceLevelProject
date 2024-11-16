//
//  WorkspaceCell.swift
//  ServiceLevelProject
//
//  Created by YJ on 10/29/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class WorkspaceCell: UITableViewCell, ViewRepresentable {
    // MARK: UI
    let bgView = UIView().then {
        $0.layer.cornerRadius = 8
    }
    
    let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
    }
    
    private let contentsStackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let nameLabel = UILabel().then {
        $0.font = .bodyBold
        $0.textColor = .textPrimary
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    let createdAtLabel = UILabel().then {
        $0.font = .body
        $0.textColor = .textSecondary
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    let editButton = UIButton().then {
        $0.setImage(UIImage(resource: .edit), for: .normal)
    }
    
    // MARK: Properties
    let disposeBag = DisposeBag()

    // MARK: View Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            bgView.backgroundColor = .brandGray
        } else {
            bgView.backgroundColor = .clear
        }
    }
    
    func addSubviews() {
        contentView.addSubview(bgView)
        bgView.addSubviews([coverImageView, contentsStackView, editButton])
        contentsStackView.addArrangedSubviews([nameLabel, createdAtLabel])
    }
    
    func setConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        bgView.snp.makeConstraints {
            $0.verticalEdges.equalTo(safeArea).inset(6)
            $0.leading.equalTo(safeArea).offset(9)
            $0.trailing.equalTo(safeArea).offset(-6)
        }
        
        coverImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalTo(bgView).inset(8)
            $0.width.height.equalTo(44)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(bgView).inset(12)
            $0.leading.equalTo(bgView).offset(60)
            $0.trailing.equalTo(bgView).offset(-50)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(contentsStackView.snp.trailing).offset(18)
            $0.verticalEdges.equalTo(bgView).inset(20)
            $0.trailing.equalTo(bgView).offset(-12)
        }
    }
    
    func configureUI() {
        backgroundColor = .clear
    }
    
    func configureCell(element: WorkspaceTestData) {
        coverImageView.image = UIImage(systemName: element.coverImage)
        nameLabel.text = element.title
        createdAtLabel.text = element.createdAt
        selectionStyle = .none
    }
    
    func configureCell(element: WorkSpace) {
        //이미지 관련 핸들링은 다녀와서 하겠습니다😂
        nameLabel.text = element.name
        createdAtLabel.text = element.createdAt
    }
}
