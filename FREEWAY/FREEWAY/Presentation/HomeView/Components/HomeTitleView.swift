//
//  HomeTitleView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then

final class HomeTitleView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeTitleView {
    func configure() {
        self.font = UIFont(name: "Pretendard-Bold", size: 28)
        self.textColor = .black
        self.numberOfLines = 2
        self.text = "엘리베이터가\n궁금한 지하철역은?"
    }
}
