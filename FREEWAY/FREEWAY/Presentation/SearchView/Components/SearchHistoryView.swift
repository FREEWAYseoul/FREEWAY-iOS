//
//  SearchHistoryView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import Then
import SnapKit

final class SearchHistoryView: UIView {
    
    struct StationInfo {
        let stationName: String
//        let stationId: String
        let lineId: String
//        let lineName: String
//        let stationCoordinate: StationCoordinate
        let stationStatus: String
    }
    
    struct StationCoordinate {
            let latitude: String
            let longitude: String
    }
    
    private var searchHistorys: [StationInfo] = [StationInfo(stationName: "강남역", lineId: "2", stationStatus: "possible")]
    
    private let searchHistoryTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 57
        $0.isScrollEnabled = true
    }
    
    private let searchHistoryLabel = UILabel().then {
        //변경 필요
        $0.textColor = .gray
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    init() {
        super.init(frame: .zero)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchHistoryView {
    
    func configure() {
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(SearchHistoryViewCell.self, forCellReuseIdentifier: SearchHistoryViewCell.searchHistoryViewCellId)
    }
    
    func setupLayout() {
        self.addSubview(searchHistoryLabel)
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
        
        self.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel).offset(13)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchHistoryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryViewCell.searchHistoryViewCellId) as? SearchHistoryViewCell else { return UITableViewCell() }
        let searchHistory = searchHistorys[indexPath.row]
        cell.configure(searchHistory.stationName, searchHistory.stationStatus, searchHistory.lineId)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    
}
