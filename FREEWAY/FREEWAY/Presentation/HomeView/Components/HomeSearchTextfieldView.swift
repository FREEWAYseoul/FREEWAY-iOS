//
//  HomeSearchTextfieldView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then

final class HomeSearchTextfieldView: UIView {
    
    var voiceImage = "mic.fill" {
        didSet {
            self.voiceRecognitionImage.image = UIImage(systemName: voiceImage)
        }
    }
    
    lazy var placeholderLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.textColor = Pallete.customBlack.color
        $0.text = "역이름을 입력해주세요"
        $0.layer.opacity = 0.5
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var voiceRecognitionImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: self.voiceImage)
        $0.tintColor = .white
    }
    
    lazy var voiceRecognitionButton = UIButton(frame: .zero).then {
        $0.backgroundColor = Pallete.customBlue.color
        $0.layer.cornerRadius = $0.bounds.size.width * 0.5
        $0.layer.cornerCurve = .circular
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = bounds.size.height / 2.0
        voiceRecognitionButton.layer.cornerRadius = 54.89 / 2
    }
}

private extension HomeSearchTextfieldView {
    func configure() {
        self.layer.cornerRadius = bounds.size.height / 2.0
        self.layer.borderWidth = 1.5 // 테두리 두께 설정
        self.layer.borderColor = Pallete.customBlue.color?.cgColor
        self.backgroundColor = .white
    }
    
    func setupLayout() {
        self.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(26)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(voiceRecognitionButton)
        
        voiceRecognitionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12.21)
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().offset(-8.11)
            make.width.equalTo(54.89)
        }
        
        voiceRecognitionButton.addSubview(voiceRecognitionImage)
        
        voiceRecognitionImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(24)
        }
        voiceRecognitionImage.adjustsImageSizeForAccessibilityContentSizeCategory = false
        
    }
}
