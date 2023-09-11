//
//  NotificationTableSection.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/11.
//

import UIKit
import Then
import SnapKit

final class NotificationTableSection: UIView {
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .black
        $0.alpha = 0.5
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = Pallete.alertPrevTimeGray.color
        $0.layer.opacity = 0.5
    }
    
    init() {
        super.init(frame: .zero)
        setupLayout()
        self.backgroundColor = .white 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var date = ""
}

extension NotificationTableSection {
    func configure(date: String) {
        self.dateLabel.text = date
        self.date = date
    }
    
    private func setupLayout() {
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
