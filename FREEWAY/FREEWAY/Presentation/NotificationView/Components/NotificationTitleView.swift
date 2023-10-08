//
//  NotificationTitleView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/10.
//

import UIKit
import SnapKit
import Then

final class NotificationTitleView: UIView {
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.textColor = .black
        $0.text = "알림"
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

private extension NotificationTitleView {
    
    func setupLayout() {
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
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
            make.centerY.equalToSuperview()
        }
    }
}
