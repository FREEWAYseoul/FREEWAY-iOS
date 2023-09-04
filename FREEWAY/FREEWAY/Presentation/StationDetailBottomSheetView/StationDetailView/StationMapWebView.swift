//
//  StationMapWebViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/02.
//

import UIKit
import SnapKit
import Then

final class StationMapWebView: UIView {
    
    private let GuidanceLabel = UILabel().then {
        $0.text = "손으로 확대, 축소가 가능해요"
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.opacity = 0.5
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Pallete.backgroundGray.color
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension StationMapWebView {
    func setupLayout() {
        self.addSubview(GuidanceLabel)
        GuidanceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
