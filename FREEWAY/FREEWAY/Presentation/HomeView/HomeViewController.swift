//
//  HomeViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/25.
//

import UIKit
import SnapKit
import Then
import RxSwift


final class HomeViewController: UIViewController {
    
    private let voiceRecognitionManager = VoiceRecognitionManager.shared
    let viewModel = BaseViewModel()
    let disposeBag = DisposeBag()
    
    private let alertButton = InAppAlertButtonView()
    private let homeTitle = HomeTitleView()
    private let textField = HomeSearchTextfieldView()
    private let recentSearchView = RecentSearchView()
    private let voiceSearchLottieView = VoiceSearchLottieView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        voiceRecognitionManager.setViewModel(viewModel: viewModel)
        setupLayout()
        NetworkService.shared.getAllStationList { stations, error in
            if let stations = stations {
                self.viewModel.stationDatas = stations
            }
            else if let error = error {
                
            }
        }
        bind()
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
            navigateToMapsViewControllerIfNeeded(voiceRecognitionManager.resultText ?? "")
        } else {
            recentSearchView.isHidden = true
            setupLottieLayout()
            voiceSearchLottieView.voiceLottieView.play()
            voiceSearchLottieView.voiceLottieView.loopMode = .loop //무한 반복
            voiceRecognitionManager.startRecognition()
        }
    }
    
    private func bind() {
        viewModel.voiceStationName
            .subscribe(onNext: { [weak self] text in
                self?.voiceSearchLottieView.resultTextLabel.text = text
            })
            .disposed(by: disposeBag)
    }
    
    @objc func tabPlaceholderLabel(sender: UITapGestureRecognizer){
        self.navigationController?.pushViewController(SearchViewController(viewModel: viewModel), animated: true)
    }
    
    private func findStationDetailDTO(_ stationName: String) -> StationDTO? {
        return MockData.mockStationDTOs.first { $0.stationName == stationName }
    }
    
    private func showInvalidStationNameAlert() {
        let alert = UIAlertController(title: "역 이름을 다시 한 번 확인해주세요!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMapsViewControllerIfNeeded(_ searchText: String) {
        if findStationDetailDTO(searchText) != nil {
            self.navigationController?.pushViewController(MapsViewController(viewModel: viewModel), animated: true)
        } else {
            showInvalidStationNameAlert()
        }
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
