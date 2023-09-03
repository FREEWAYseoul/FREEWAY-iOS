//
//  FacilitiesViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/02.
//

import UIKit
import Then
import SnapKit

final class FacilitiesView: UIView {
    
    private let data = MockData.mockStationDetail
    private let facilitiesTitles = ["장애인 화장실", "휠체어 리프트", "유아수유방", "환전키오스크", "무인민원발급기", "환승주차장"]
    
    let updateTimeLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.textColor = Pallete.updatedTextGray.color
        $0.text = "0/00 0요일 00:00 업데이트 완료"
    }
    
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = 53
        $0.isScrollEnabled = true
        $0.separatorStyle = .none
    }
    
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

private extension FacilitiesView {
    func configure() {
        tableView.register(FacilitiesTableViewCell.self, forCellReuseIdentifier: FacilitiesTableViewCell.facilitiesCellId)
        tableView.dataSource = self
    }
    
    func setupLayout() {
        self.addSubview(updateTimeLabel)
        updateTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(updateTimeLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension FacilitiesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        facilitiesTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacilitiesTableViewCell.facilitiesCellId) as? FacilitiesTableViewCell else { return UITableViewCell() }
        cell.configure("wheelchairLift", data.facilities.wheelchairLift, "휠체어 리프트")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
