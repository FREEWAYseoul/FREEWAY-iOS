//
//  EmptyView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import Then
import SnapKit

final class EmptyView: UIView {
    //추후에 TextField와 데이터 바인딩 필요
    var searchText: String = "" {
        didSet {
            emptySearchTitleLabel.text = "\"\(searchText)\" 검색 결과가 없습니다."
        }
    }
    
    lazy var emptySearchTitleLabel = UILabel().then {
        $0.textColor = Pallete.customGray.color
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 20)
    }
    
    private let emptySearchImage = UIImageView().then {
        $0.image = UIImage(named: "error")
        $0.contentMode = .scaleAspectFill
        $0.tintColor = Pallete.customGray.color
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = Pallete.backgroundGray.color
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyView {
    
    func setupLayout() {
        self.addSubview(emptySearchImage)
        emptySearchImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(147.4)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.addSubview(emptySearchTitleLabel)
        emptySearchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptySearchImage.snp.bottom).offset(19.6)
            make.centerX.equalToSuperview()
        }
    }
}

