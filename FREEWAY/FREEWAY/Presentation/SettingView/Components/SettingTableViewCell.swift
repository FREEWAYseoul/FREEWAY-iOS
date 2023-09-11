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
    }
    
    func configureUI(title: String) {
        self.settingTitleLabel.text = title
    }
}

