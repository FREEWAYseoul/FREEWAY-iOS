//
//  InAppAlertButtonView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/26.
//

import UIKit
import SnapKit
import Then

final class InAppAlertButtonView: UIButton {
    private let alertDot = UIView().then {
        $0.backgroundColor = Pallete.alertDotRed.color
        $0.layer.cornerRadius = 4.5
    }
    
    private let alertImageView = UIImageView().then {
        $0.image = UIImage(named: "alert")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Pallete.alertIconGray.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        //TODO: 알람이 있을 시에 대한 분기처리가 필요한 부분
        isAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isAlert() {
        alertImageView.image = UIImage(named: "alertDot")
        self.addSubview(alertDot)
        alertDot.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2.7)
            make.width.height.equalTo(9)
        }

    }
}

private extension InAppAlertButtonView {
    func setupLayout() {
        self.addSubview(alertImageView)
        alertImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
