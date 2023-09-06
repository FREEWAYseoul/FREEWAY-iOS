//
//  SearchListView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/06.
//

import UIKit
import Then
import SnapKit

final class SearchListView: SearchHistoryBaseView {
    
    var datas: [StationDTO]
    
    private let divider = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    init(datas: [StationDTO]) {
        self.datas = datas
        super.init(frame: .zero)
        self.backgroundColor = Pallete.backgroundGray.color
        configure()
        setupLayout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchListView {
    
    func configure() {
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.register(SearchHistoryBaseViewCell.self, forCellReuseIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId)
    }
    
    func setupLayout() {
        self.addSubview(searchHistoryTableView)
        searchHistoryTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId) as? SearchHistoryBaseViewCell else { return UITableViewCell() }
        let searchData = datas[indexPath.row]
        cell.configure(searchData.stationName, searchData.stationStatus, searchData.lineId)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
