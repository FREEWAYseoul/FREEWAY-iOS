//
//  CurrentLocationButton.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/29.
//

import UIKit
import SnapKit
import Then

final class CurrentLocationButton: UIButton {
    private let iconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "currentLocationIcon")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurrentLocationButton {
    func configure() {
        self.addSubview(iconView)
        self.backgroundColor = .white
        self.layer.cornerRadius = 6.67
        self.layer.borderWidth = 0.83
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16.67)
        }
        
        iconView.isUserInteractionEnabled = false
    }
}
