//
//  RecentSearchView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then

final class RecentSearchView: SearchHistoryBaseView {
    
    //TODO: 추후 userdefaults 변수로 변경 필요 및 SearchViewController와 연결 필요
    let searchHistorys: [StationInfo] = [StationInfo(stationName: "강남", lineId: "2", stationStatus: "possible"),StationInfo(stationName: "신촌", lineId: "2", stationStatus: "possible")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RecentSearchView {
    
    func configure() {
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(SearchHistoryBaseViewCell.self, forCellReuseIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId)
    }
    
    func setupLayout() {
        self.addSubview(searchHistoryLabel)
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        self.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension RecentSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId) as? SearchHistoryBaseViewCell else { return UITableViewCell() }
        let searchHistory = searchHistorys[indexPath.row]
        cell.configure(searchHistory.stationName, searchHistory.stationStatus, searchHistory.lineId, false, 0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
