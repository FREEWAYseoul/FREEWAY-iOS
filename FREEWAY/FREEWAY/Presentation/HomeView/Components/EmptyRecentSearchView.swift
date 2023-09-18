//
//  EmptyRecentSearchView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/26.
//

import UIKit
import SnapKit
import Then

final class EmptyRecentSearchView: SearchHistoryBaseView {
    
    private let emptyView = UIView().then {
        $0.backgroundColor = Pallete.backgroundGray.color
        $0.layer.cornerRadius = 10
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "최근 검색어가 없습니다."
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.textColor = .black
        $0.alpha = 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyRecentSearchView {
    func configure() {
        searchHistoryLabel.text = ""//"혜택 챙겨가세요!"
    }
    
    func setupLayout() {
        self.addSubview(searchHistoryLabel)
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-49)
        }
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
}
