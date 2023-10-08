//
//  SettingTitleView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/12.
//

import UIKit
import Then
import SnapKit

final class SettingTitleView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.textColor = .black
        $0.text = "설정"
        $0.sizeToFit()
    }

    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "icon-arrow-right")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    let seperator = UIView().then {
        $0.backgroundColor = Pallete.updatedTextGray.color
        $0.layer.opacity = 0.5
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingTitleView {
    
    func setupLayout() {
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        backButton.addSubview(backButtonImage)
        backButtonImage.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
            make.width.equalTo(24)
        }
        backButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(7)
            make.centerY.equalTo(backButton)
        }
        
        self.addSubview(seperator)
        seperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
