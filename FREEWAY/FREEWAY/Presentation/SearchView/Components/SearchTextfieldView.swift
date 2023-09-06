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
    
    let viewModel: BaseViewModel
    let searchTextfield = UITextField().then {
        $0.borderStyle = .none
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        $0.textColor = Pallete.customBlack.color
        $0.attributedPlaceholder = NSAttributedString(string: "역 이름을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : Pallete.customGray.color?.withAlphaComponent(0.5) ?? UIColor.gray, NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18)])
    }
    
    var voiceRecognitionImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "mic.fill")
        $0.tintColor = Pallete.customBlue.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var voiceRecognitionButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let backButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(named: "icon-arrow-right")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .white
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
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(searchTextfield.snp.leading).offset(-17)
        }
        
        backButton.addSubview(backButtonImage)
        backButtonImage.snp.makeConstraints { make in
            make.bottom.top.leading.equalToSuperview()
            make.width.equalTo(24)
        }
        backButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(voiceRecognitionButton)
        voiceRecognitionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.top.equalToSuperview()
        }
        voiceRecognitionButton.addSubview(voiceRecognitionImage)
        voiceRecognitionImage.isUserInteractionEnabled = false
        
        voiceRecognitionImage.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.width.equalTo(22)
        }
    }
}
