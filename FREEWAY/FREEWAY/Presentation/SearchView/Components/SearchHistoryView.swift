//
//  SearchHistoryView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import Then
import SnapKit

final class SearchHistoryView: SearchHistoryBaseView {
    
    let viewModel: BaseViewModel
    
    private let divider = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = Pallete.backgroundGray.color
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
        searchHistoryTableView.register(SearchHistoryBaseViewCell.self, forCellReuseIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId)
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

extension SearchHistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaults.standard.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryBaseViewCell.searchHistoryViewCellId) as? SearchHistoryBaseViewCell else { return UITableViewCell() }
        let searchHistory = UserDefaults.standard.searchHistory[indexPath.row]
        cell.configure(data: viewModel.getStationDTOWithId(id: searchHistory)!)
        cell.backgroundColor = .clear
        cell.selectionStyle = .default
        return cell
    }
}
