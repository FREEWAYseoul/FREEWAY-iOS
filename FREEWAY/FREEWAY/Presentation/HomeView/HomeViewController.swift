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
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    
    private let alertButton = InAppAlertButtonView()
    private let homeTitle = HomeTitleView()
    private let textField = HomeSearchTextfieldView()
    private let voiceSearchLottieView = VoiceSearchLottieView()
    
    private lazy var searchListModule = HomeSearchListViewController(viewModel: self.viewModel)
    lazy var settingButton = UIButton().then {
        $0.setImage(.init(named: "Setting"), for: .normal)
        $0.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
    }
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        voiceRecognitionManager.setViewModel(viewModel: viewModel)
        setupLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.hasNewerDate() {
            alertButton.image = "alertDot"
        } else {
            alertButton.image = "alert"
        }
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
        searchListModule.view.isHidden = true
        setupLottieLayout()
        voiceSearchLottieView.voiceLottieView.play()
        voiceSearchLottieView.voiceLottieView.loopMode = .loop //무한 반복
        voiceRecognitionManager.startRecognition()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.searchListModule.view.isHidden = false
            self.voiceRecognitionManager.stopRecognition()
            self.voiceSearchLottieView.removeFromSuperview()
            self.navigateToMapsViewControllerIfNeeded(self.voiceRecognitionManager.resultText ?? "")
        }
    }
    
    @objc func notiButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(NotificationViewController(viewModel: viewModel), animated: true)
    }
    
    @objc func settingButtonPressed(_ sender: UIButton) {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
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
    
    private func showInvalidStationNameAlert() {
        let alert = UIAlertController(title: "역 이름을 다시 한 번 확인해주세요!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMapsViewControllerIfNeeded(_ searchText: String) {
        if viewModel.getStationDTO() != nil {
            viewModel.getCurrentStationDetailData(stationData: viewModel.currentStationData)
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
        alertButton.addTarget(self, action: #selector(notiButtonPressed), for: .touchUpInside)
        textField.placeholderLabel.addGestureRecognizer(placeHolderGesture)
    }
    
    func setupLayout() {
        view.addSubview(alertButton)
        alertButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 32.09)
            make.trailing.equalToSuperview().offset(-61.1)
            make.width.equalTo(25)
        }
        
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(alertButton)
            make.leading.equalTo(alertButton.snp.trailing).offset(12.1)
            make.height.width.equalTo(30)
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
        self.addChild(searchListModule)
        self.view.addSubview(searchListModule.view)
        searchListModule.didMove(toParent: self)
        searchListModule.view.snp.makeConstraints { make in
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

