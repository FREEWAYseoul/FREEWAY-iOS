//
//  HomeSearchListViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/13.
//

import UIKit
import SnapKit
import Then

final class HomeSearchListViewController: UIViewController {
    
    let viewModel: BaseViewModel
    
    private lazy var recentSearchView = RecentSearchView(viewModel: viewModel)
    private let emptyRecentView = EmptyRecentSearchView()
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentSearchView.searchHistoryTableView.reloadData()
    }
    
    private func showInvalidStationNameAlert() {
        let alert = UIAlertController(title: "역 이름을 다시 한 번 확인해주세요!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

private extension HomeSearchListViewController {
    
    func configure() {
        recentSearchView.searchHistoryTableView.delegate = self
        recentSearchView.isHidden = UserDefaults.standard.searchHistory.isEmpty
    }
    
    func setupLayout() {
        view.addSubview(recentSearchView)
        recentSearchView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        if recentSearchView.isHidden {
            view.addSubview(emptyRecentView)
            emptyRecentView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
}


extension HomeSearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? SearchHistoryBaseViewCell {
            if let cellData = cell.cellData {
                viewModel.currentStationData = cellData
                viewModel.updateText(cellData.stationName)
                self.navigationController?.pushViewController(MapsViewController(viewModel: viewModel), animated: true)
            }
            else {
                showInvalidStationNameAlert()
            }
        }
    }
}
