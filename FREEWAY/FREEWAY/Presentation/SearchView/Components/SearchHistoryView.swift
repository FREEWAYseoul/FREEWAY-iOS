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
    //MARK: Model로 추후 변경 필요
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
    
    private var searchHistorys: [StationInfo] = [StationInfo(stationName: "강남", lineId: "2", stationStatus: "possible"),StationInfo(stationName: "신촌", lineId: "2", stationStatus: "possible")]
    
    private let searchHistoryTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 57
        $0.isScrollEnabled = true
    }
    
    private let searchHistoryLabel = UILabel().then {
        //변경 필요
        $0.textColor = .darkGray
        $0.text = "최근 검색"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .lightGray
        configure()
        setupLayout()
        
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
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(17)
        }
        
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(13)
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
