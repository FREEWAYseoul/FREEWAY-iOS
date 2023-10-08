//
//  SettingTableViewCell.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import UIKit
import SnapKit
import Then

final class SettingTableViewCell: UITableViewCell {
    static let settingId = "SettingCell"
    private let settingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let navigationArrowImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.forward"))
        image.tintColor = Pallete.updatedTextGray.color
        return image
    }()
    
    private let seperator = UIView().then {
        $0.backgroundColor = Pallete.updatedTextGray.color
        $0.layer.opacity = 0.5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupLayout(){
        addSubview(settingTitleLabel)
        settingTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        addSubview(navigationArrowImageView)
        navigationArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        
        addSubview(seperator)
        seperator.snp.makeConstraints { make in
            make.top.equalTo(settingTitleLabel.snp.bottom).offset(13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configureUI(title: String, isLastCell: Bool) {
        self.settingTitleLabel.text = title
        self.seperator.isHidden = isLastCell ? true : false
    }
}

