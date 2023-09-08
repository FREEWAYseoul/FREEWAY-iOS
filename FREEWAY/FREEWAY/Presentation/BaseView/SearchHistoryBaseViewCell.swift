//
//  SearchHistoryBaseViewCell.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import SnapKit
import Then

final class SearchHistoryBaseViewCell: UITableViewCell {
    
    private var horizontalOffset = 20
    
    static let searchHistoryViewCellId = "SearchHistoryViewCell"
    
    let stationTitleLabel = UILabel().then {
        //변경 필요
        $0.textColor = Pallete.customBlack.color
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    }
    
    private let stationStateImage = UIImageView()
    
    private let stationLineImage = UIImageView()
    
    private let divider = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SearchHistoryBaseViewCell {
    
    private func setupLayout() {
        self.addSubview(stationTitleLabel)
        stationTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(horizontalOffset)
        }
        
        self.addSubview(stationStateImage)
        stationStateImage.snp.makeConstraints { make in
            make.leading.equalTo(stationTitleLabel.snp.trailing).offset(6)
            make.centerY.equalTo(stationTitleLabel)
            make.height.equalTo(21)
            make.width.equalTo(57)
        }
        
        self.addSubview(stationLineImage)
        stationLineImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.centerY.equalTo(stationTitleLabel)
            make.height.width.equalTo(28)
        }
        
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.bottom.equalTo(stationTitleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(_ title: String, _ status: String, _ line: String, _ separaterState: Bool? = true, _ horizontalOffset: Int? = 20) {
        stationTitleLabel.text = title
        stationStateImage.image = UIImage(named: status == "사용 가능" ? "possible" : "impossible")
        stationLineImage.image = UIImage(named: line)
        if horizontalOffset == 0 {
            stationTitleLabel.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(horizontalOffset ?? 20)
            }
            stationStateImage.snp.updateConstraints { make in
                make.leading.equalTo(stationTitleLabel.snp.trailing).offset(6)
            }
            stationLineImage.snp.updateConstraints { make in
                make.trailing.equalToSuperview().offset(-(horizontalOffset ?? 20))
            }
        }
        
        if separaterState == false { divider.isHidden = true }
    }
}
