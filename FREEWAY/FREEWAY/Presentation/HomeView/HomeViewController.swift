//
//  HomeViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    private let voiceRecognitionManager = VoiceRecognitionManager.shared
    
    private let alertButton = InAppAlertButtonView()
    private let homeTitle = HomeTitleView()
    private let textField = HomeSearchTextfieldView()
    private let recentSearchView = RecentSearchView()
    private let voiceSearchLottieView = VoiceSearchLottieView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        setupLayout()
    }
    //TODO: BaseViewController 구현 후에 옮기기
    private func safeAreaTopInset() -> CGFloat? {
        if #available(iOS 15.0, *) {
            let topArea = UIApplication.shared.windows.first?.safeAreaInsets.top
            return topArea
        } else {
            return nil
        }
    }
    
    @objc func voiceButtonPressed(_ sender: UIButton) {
        if voiceRecognitionManager.isRecognizing {
            recentSearchView.isHidden = false
            voiceRecognitionManager.stopRecognition()
            voiceSearchLottieView.removeFromSuperview()
            //TODO: 로직적으로 보완되어야할 부분 텍스트 색 변경 및 텍스트 없을 시에 그대로 유지
            if let resultText = voiceRecognitionManager.resultText {
                textField.placeholderLabel.text = resultText
                textField.placeholderLabel.textColor = Pallete.customBlack.color
                textField.placeholderLabel.layer.opacity = 1.0
            }
            
            
        } else {
            recentSearchView.isHidden = true
            setupLottieLayout()
            voiceSearchLottieView.voiceLottieView.play()
            voiceSearchLottieView.voiceLottieView.loopMode = .loop //무한 반복
            voiceRecognitionManager.startRecognition()
            //TODO: 추후 Rxswift를 활용한 ViewModel 연동 시에 수정될 부분
            //voiceSearchLottieView.updateResultText("강남역")
        }
    }
    
    @objc func tabPlaceholderLabel(sender: UITapGestureRecognizer){
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

private extension HomeViewController {
    
    func configure() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        textField.voiceRecognitionButton.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        let placeHolderGesture = UITapGestureRecognizer(target: self, action: #selector(tabPlaceholderLabel))
        textField.placeholderLabel.addGestureRecognizer(placeHolderGesture)
    }
    
    func setupLayout() {
        view.addSubview(alertButton)
        alertButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 32.09)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(29)
        }
        
        view.addSubview(homeTitle)
        homeTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 162)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(homeTitle.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(72)
        }
        
        view.addSubview(recentSearchView)
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(74)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupLottieLayout() {
        view.addSubview(voiceSearchLottieView)
        voiceSearchLottieView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-200)
            make.leading.equalToSuperview().offset(-45)
            make.trailing.equalToSuperview().offset(45)
        }
    }
}
