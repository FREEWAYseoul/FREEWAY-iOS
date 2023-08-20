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
    
    let searchTextfield = UITextField().then {
        $0.borderStyle = .none
        $0.attributedPlaceholder = NSAttributedString(string: "역 이름을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
    }
    
    private let voiceRecognitionImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "mic.fill")
        $0.tintColor = .blue
    }
    
    lazy var voiceRecognitionButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "chevron.right")
        $0.tintColor = .gray
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
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
        self.addSubview(searchTextfield)
        
        searchTextfield.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(54)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        self.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(searchTextfield).offset(-17)
        }
        
        backButton.addSubview(backButtonImage)
        
        backButtonImage.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
        }
        
        self.addSubview(voiceRecognitionButton)
        
        voiceRecognitionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.top.equalToSuperview()
        }
        
        voiceRecognitionButton.addSubview(voiceRecognitionImage)
        
        voiceRecognitionImage.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(24)
        }
        
    }
    
}
