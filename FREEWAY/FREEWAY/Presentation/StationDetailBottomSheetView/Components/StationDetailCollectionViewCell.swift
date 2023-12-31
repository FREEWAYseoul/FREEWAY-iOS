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
    
    var unavailableButtonColor = Pallete.unavailableFacilitiesGray.color {
        didSet {
            self.iconView.image = image?.withRenderingMode(.alwaysTemplate)
            self.iconView.tintColor = self.unavailableButtonColor
            self.iconLabel.textColor = self.unavailableButtonColor
        }
    }
    
    var image: UIImage?
    
    private var iconView = UIImageView().then {
        $0.tintColor = Pallete.unavailableFacilitiesGray.color
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
    
    override var isSelected: Bool {
        didSet {
            self.iconView.image = image?.withRenderingMode(.alwaysTemplate)
            self.iconView.tintColor = self.isSelected ? Pallete.customBlue.color : .black
            self.iconView.layer.opacity = self.isSelected ? 1.0 : 0.5
            
            self.iconLabel.textColor = self.isSelected ? Pallete.customBlue.color : .black
            self.iconLabel.layer.opacity = self.isSelected ? 1.0 : 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StationDetailCollectionViewCell {
    func configure(_ imageName: String, _ title: String) {
        image = UIImage(named: imageName)
        iconView.image = image
        iconView.image?.withRenderingMode(.alwaysTemplate)
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
            make.centerY.equalTo(iconView)
            make.trailing.equalToSuperview()
        }
        
        self.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(16)
            make.centerX.equalTo(iconView)
        }
    }
}
