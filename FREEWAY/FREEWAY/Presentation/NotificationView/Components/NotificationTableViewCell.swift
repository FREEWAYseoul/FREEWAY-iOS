//
//  NotificationTableViewCell.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/10.
//

import UIKit
import Then
import SnapKit

final class NotificationTableViewCell: UITableViewCell {
    static let notiCellId = "NotificationViewCell"
    
    private lazy var timeDot = UIView().then {
        $0.layer.cornerRadius = 6
    }
    
    private lazy var time = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    private var title = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.textColor = Pallete.customBlack.color
        
    }
    
    private var body = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.textColor = Pallete.customBlack.color
        $0.sizeToFit()
        $0.numberOfLines = 0
    }
    

    var isToday: Bool = false {
        didSet {
            timeDot.backgroundColor = self.isToday ? Pallete.alertTimeRed.color : Pallete.alertPrevTimeGray.color
            time.textColor = self.isToday ? Pallete.alertTimeRed.color : Pallete.alertPrevTimeGray.color
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

extension NotificationTableViewCell {
    func configure(data: NotificationDataDTO, isToday: Bool) {
        self.isToday = isToday
        self.title.text = data.summary
        self.time.text = data.time
        self.body.text = data.content
    }
    
    private func setupLayout() {
        
        self.addSubview(timeDot)
        timeDot.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        self.addSubview(time)
        time.snp.makeConstraints { make in
            make.centerY.equalTo(timeDot)
            make.leading.equalTo(timeDot.snp.trailing).offset(9)
        }
        
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(timeDot.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(body)
        body.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

