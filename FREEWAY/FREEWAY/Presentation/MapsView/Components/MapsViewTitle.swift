//
//  MapsViewTitle.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/06.
//

import UIKit
import SnapKit
import Then

final class MapsViewTitle: UIView {
    let currentTextLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = Pallete.customBlack.color
    }
    
    var closeImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "x.circle.fill")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var closeButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "icon-arrow-right")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MapsViewTitle {
    
    func setupLayout() {
        self.addSubview(currentTextLabel)
        currentTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(54)
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(currentTextLabel.snp.leading).offset(-17)
        }
        
        backButton.addSubview(backButtonImage)
        backButtonImage.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
            make.width.equalTo(24)
        }
        backButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.top.equalToSuperview()
        }
        closeButton.addSubview(closeImage)
        closeImage.isUserInteractionEnabled = false
        
        closeImage.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.width.equalTo(22)
        }
    }
}
