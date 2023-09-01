//
//  StationDetailCollectionViewCell.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/30.
//

import UIKit
import SnapKit
import Then

final class StationDetailCollectionViewCell: UICollectionViewCell {
    
    static let stationDetailCollectionViewCellId = "stationDetailCollectionViewCellId"
    
    var image: UIImage?
    
    private var iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private var iconLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.layer.opacity = 0.5
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    var selectStatus: Bool = false {
        didSet {
            self.iconView.tintColor = self.selectStatus ? Pallete.customBlue.color : .black
            self.iconView.layer.opacity = self.selectStatus ? 1.0 : 0.5
            
            self.iconLabel.textColor = self.selectStatus ? Pallete.customBlue.color : .black
            self.iconLabel.layer.opacity = self.selectStatus ? 1.0 : 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StationDetailCollectionViewCell {
    func configure(_ imageName: String, _ title: String) {
        image = UIImage(named: imageName)
        iconView.image = image
        iconLabel.text = title
    }
    
    private func setupLayout() {
        self.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
            make.leading.equalTo(32)
        }
        
        self.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView).offset(16)
            make.centerX.equalTo(iconView)
        }
    }
}
