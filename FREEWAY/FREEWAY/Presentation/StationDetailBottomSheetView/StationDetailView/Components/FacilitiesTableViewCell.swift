//
//  FacilitiesTableViewCell.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/02.
//

import UIKit
import SnapKit
import Then

final class FacilitiesTableViewCell: UITableViewCell {
    static let facilitiesCellId = "FacilitiesTableViewCell"
    
    private var title = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = Pallete.customBlack.color
    }
    
    private var statusImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Pallete.customBlack.color
    }
    
    private var separater = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    var status: Bool = false {
        didSet {
            title.layer.opacity = self.status ? 1 : 0.5
            iconView.layer.opacity = self.status ? 1 : 0.5
            statusImage.image = self.status ? UIImage(named: "possible") : UIImage(named: "impossible")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FacilitiesTableViewCell {
    func configure(_ icon: String, _ status: Bool, _ title: String) {
        self.status = status
        self.iconView.image = UIImage(named: icon)
        self.title.text = title
    }
    
    func setupLayout() {
        self.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(21)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(8)
        }
        
        self.addSubview(statusImage)
        statusImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(title.snp.trailing).offset(8)
            make.width.equalTo(57)
        }
        
        self.addSubview(separater)
        separater.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

    }
}
