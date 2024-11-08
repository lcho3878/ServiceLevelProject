//
//  ChattingViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/5/24.
//

import UIKit

final class ChattingViewController: BaseViewController {
    private let chattingView = ChattingView()
    
    override func loadView() {
        view = chattingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("chat VC load")
        configureTableView()
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        chattingView.chattingTableView.delegate = self
        chattingView.chattingTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChattingTestData.testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingTableViewCell.id, for: indexPath) as? ChattingTableViewCell else { return UITableViewCell() }
        let data = ChattingTestData.testData[indexPath.row]
        cell.configureData(data)
        return cell
    }
    
    
}

extension ChattingViewController {
    
}

struct ChattingData {
    let nickname: String
    let message: String?
    let date: Date = Date()
    let images: [UIImage]
    let profileImage: UIImage?
}

struct ChattingTestData {
    static let testData: [ChattingData] = [
        .init(nickname: "옹골찬 고래밥", message: "저희 수료식이 언제였죠? 11/9 맞나요? 영등포 캠퍼스가 어디에 있었죠? 기억이...ㅜ", images: [], profileImage: .closeMark),
        .init(nickname: "옹골찬 블루베리", message: "수료식수료식수료식\n이미지 1개용", images: [.kakao], profileImage: .kakao),
        .init(nickname: "블루베리 옹골찬", message: "수료식 사진 공유드려요2!\n이미지 2개용", images: [.kakao, .kakao], profileImage: .kakao),
        .init(nickname: "블루ㅁㄴㅇㄹ베리", message: "하퇴근\n이미지 3개용", images: [.kakao, .kakao, .kakao], profileImage: .kakao),
        .init(nickname: "블루ㅋㅋ베리", message: "늘어나라늘어나라늘어나라늘어나라늘어나라늘어나라\n이미지 4개용", images: [.kakao, .kakao, .kakao, .kakao], profileImage: .kakao),
        .init(nickname: "블루베리", message: "수료식 사진 공유드려요5!\n이미지 5개용", images: [.kakao, .kakao, .kakao, .workspaceEmpty, .kakao], profileImage: .kakao),
        .init(nickname: "블루베리", message: "이미지 5개용", images: [.workspaceEmpty, .workspaceEmpty, .workspaceEmpty, .workspaceEmpty, .workspaceEmpty], profileImage: .kakao),
        .init(nickname: "Happy_Campus", message: "창작촌 맛집 추천 받습니다~\n생각보다 문래에 맛집이 많은거 같은데 제가 잘 모르더라구요!!\n맛잘알 계신가요?🥹", images: [], profileImage: nil),
        .init(nickname: "❤️데미소다❤️", message: "하\n드디어 퇴근...", images: [], profileImage: .question),
        .init(nickname: "사진만 보내는 사람", message: nil, images: [.email], profileImage: nil),
        .init(nickname: "닉네임닉네임닉네임닉네임닉네임닉네임닉네임닉네임닉네임", message: "ㄴㅇㅇ", images: [], profileImage: .kakao)
    ]
}
