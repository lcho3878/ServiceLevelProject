//
//  SearchChannelViewController.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/8/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchChannelViewController: BaseViewController, DismissButtonPresentable {
    // MARK: Properties
    private let searchChannelView = SearchChannelView()
    let viewModel = SearchChannelViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchChannelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        bind()
    }
    
    override func configureNavigation() {
        title = "채널 탐색"
    }
}

extension SearchChannelViewController: RootViewTransitionable {
    private func bind() {
        let input = SearchChannelViewModel.Input(modelSelected: searchChannelView.tableView.rx.modelSelected(ChannelListModel.self))
        let output = viewModel.transform(input: input)
        
        // viewDidLoadTrigger
        input.viewDidLoadTrigger.onNext(())
        
        // 채널 탐색 리스트
        output.searchChannelList
            .bind(to: searchChannelView.tableView.rx.items(cellIdentifier: SearchChannelCell.id, cellType: SearchChannelCell.self)) { (row, element, cell) in
                cell.configureCell(element: element)
            }
            .disposed(by: disposeBag)
        
        searchChannelView.tableView.rx.itemSelected
            .flatMapLatest { [weak self] indexPath -> Observable<IndexPath> in
                guard let self = self else { return .empty() }
                self.searchChannelView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                
                return Observable.just(indexPath)
                    .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            }
            .bind(with: self) { owner, indexPath in
                owner.searchChannelView.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.goToMyChannel
            .bind(with: self) { owner, selectedData in
                // 채팅뷰로 바로 이동
                let vc = ChattingViewController()
                vc.viewModel.chattingRoomInfo.onNext(selectedData)
                owner.changeRootViewController(rootVC: vc, isNavigation: true)
            }
            .disposed(by: disposeBag)
        
        output.goToChannelJoin
            .bind(with: self) { owner, selectedData in
                let alertVC = DoubleButtonAlertViewController()
                alertVC.modalPresentationStyle = .overFullScreen
                alertVC.setConfigure(
                    title: "채널 참여", subTitle: "[\(selectedData.name)] 채널에 참여하시겠습니까?", buttonTitle: "확인") {
                        let vc = ChattingViewController()
                        vc.viewModel.chattingRoomInfo.onNext(selectedData)
                        owner.changeRootViewController(rootVC: vc, isNavigation: true)
                    }
                
                self.present(alertVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
