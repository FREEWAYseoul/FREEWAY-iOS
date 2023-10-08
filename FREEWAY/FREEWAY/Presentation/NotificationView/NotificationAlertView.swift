//
//  NotificationAlertView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/24.
//

import UIKit
import SnapKit
import Then

final class NotificationAlertView: UIView {
    
    let alertIconView = UIImageView().then {
        $0.image = UIImage(named: "alert")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
    }
    
    let titleLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.numberOfLines = 0
        $0.sizeToFit()
        $0.textColor = .white
    }
    
    let bodyLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    init(data: [NotificationDTO]) {
        super.init(frame: .zero)
        configure(data: data)
        setupLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NotificationAlertView {
    func configure(data: [NotificationDTO]) {
        if let latestData = data.last {
            self.titleLabel.text = latestData.notifications.last?.summary
            self.bodyLabel.text = latestData.notifications.last?.content
        }
        self.backgroundColor = Pallete.alertbgGray.color
        self.layer.cornerRadius = 17.33
    }
    
    func setupLayout() {
        self.addSubview(alertIconView)
        alertIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(18)
            make.width.height.equalTo(18)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(alertIconView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1.5)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-18)
        }
    }
}
