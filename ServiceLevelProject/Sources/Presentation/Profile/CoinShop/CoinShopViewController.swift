//
//  CoinShopViewController.swift
//  ServiceLevelProject
//
//  Created by 이찬호 on 11/2/24.
//

import UIKit

final class CoinShopViewController: BaseViewController {
    private let coinshopView = CoinShopView()
    
    override func loadView() {
        view = coinshopView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func configureNavigation() {
        title = "코인샵"
    }
}

extension CoinShopViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        coinshopView.coinTableView.delegate = self
        coinshopView.coinTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoinTableViewContent.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.id, for: indexPath) as? CoinTableViewCell else { return UITableViewCell() }
        let data = CoinTableViewContent.allCases[indexPath.row]
        cell.configureData(data)
        return cell
    }
}

extension CoinShopViewController {
    enum CoinTableViewContent: CaseIterable, TableViewRepresentable {
        case ten
        case fifty
        case hundred
        
        var titleString: String {
            switch self {
            case .ten:
                "🌱 10 Coin"
            case .fifty:
                "🌱 50 Coin"
            case .hundred:
                "🌱 100 Coin"
            }
        }
        
        var subTitleString: String {
            switch self {
            case .ten:
                "￦100"
            case .fifty:
                "￦500"
            case .hundred:
                "￦1000"
            }
        }
    }
}

protocol TableViewRepresentable {
    var titleString: String { get }
    var subTitleString: String { get }
}
