//
//  EmptyHistoryView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/21.
//

import UIKit
import SnapKit
import Then

final class EmptyHistoryView: UIView {
    
    private let emptyTitleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.text = "궁금한 역을 검색할 수 있어요"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    
    private let emptyImage = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .darkGray
    }
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyHistoryView {
    
    func setupLayout() {
        self.addSubview(emptyImage)
        emptyImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(147.4)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.addSubview(emptyTitleLabel)
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom).offset(19.6)
            make.centerX.equalToSuperview()
        }
    }
}
