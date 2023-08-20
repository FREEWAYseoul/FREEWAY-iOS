//
//  SearchTextfieldView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import SnapKit
import Then

final class SearchTextfieldView: UIView {
    
    private let searchTextfield = UITextField(frame: .zero, primaryAction: .none).then {
        $0.borderStyle = .none
        $0.placeholder = "역 이름을 입력해주세요"
    }
    
    private let voiceRecognitionImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "mic.fill")
        $0.tintColor = .blue
    }
    
    private let voiceRecognitionButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "chevron.right")
        $0.tintColor = .gray
    }
    
    private let backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchTextfieldView {
    
    func setupLayout() {
        self.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
        }
        
        backButton.addSubview(backButtonImage)
        
        backButtonImage.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
        }
        backButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(searchTextfield)
        
        searchTextfield.snp.makeConstraints { make in
            make.leading.equalTo(backButton).offset(17)
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(voiceRecognitionImage)
        
        voiceRecognitionImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.top.equalToSuperview()
        }
        
    }
    
}
