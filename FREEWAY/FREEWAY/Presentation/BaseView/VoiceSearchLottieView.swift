//
//  VoiceSearchLottieView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import UIKit
import Then
import SnapKit
import Lottie

final class VoiceSearchLottieView: UIView {
    
    private let voiceRecognitionImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "mic.fill")
        $0.tintColor = .white
    }
    
    let resultTextLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.text = "듣고 있어요"
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
    }
    
    private let resultTextBackgroundView = UIView().then {
        $0.backgroundColor = Pallete.voiceTextBackground.color
        $0.layer.cornerRadius = 37/2
    }
    
    let voiceLottieView: LottieAnimationView = .init(name: "VoiceLottie")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupLayout()
        setupResultTextViewLayout()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateResultText(_ resultText: String) {
        resultTextLabel.text = resultText
        resultTextBackgroundView.backgroundColor = .black
        resultTextLabel.layoutIfNeeded()
        setupResultTextViewLayout(resultTextLabel.frame.width + 36)
    }
}

private extension VoiceSearchLottieView {
    func configure() {
        voiceLottieView.contentMode = .scaleAspectFit
        voiceLottieView.center = self.center
        
    }
    
    func setupLayout() {
        self.addSubview(voiceLottieView)
        voiceLottieView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        voiceLottieView.addSubview(voiceRecognitionImage)
        voiceRecognitionImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(24)
        }
    }
    
    func setupResultTextViewLayout(_ width: CGFloat? = 118) {
        self.addSubview(resultTextBackgroundView)
        resultTextBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(voiceRecognitionImage.snp.top).offset(-59)
            make.centerX.equalToSuperview()
            make.width.equalTo(width ?? 118)
            make.height.equalTo(37)
        }
        
        resultTextBackgroundView.addSubview(resultTextLabel)
        resultTextLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
