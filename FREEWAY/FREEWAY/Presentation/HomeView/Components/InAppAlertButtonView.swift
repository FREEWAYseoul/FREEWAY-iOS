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
    
    var image = "alert" {
        didSet {
            alertImageView.image = UIImage(named: self.image)
        }
    }
    
    private lazy var alertImageView = UIImageView().then {
        $0.image = UIImage(named: self.image)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Pallete.alertIconGray.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        //TODO: 알람이 있을 시에 대한 분기처리가 필요한 부분
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
