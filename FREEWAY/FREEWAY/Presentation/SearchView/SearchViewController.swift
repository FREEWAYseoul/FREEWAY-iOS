//
//  SearchViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import SnapKit
import Then

//TODO: Model로 추후 변경 필요
struct StationInfo {
    let stationName: String
//        let stationId: String
    let lineId: String
//        let lineName: String
//        let stationCoordinate: StationCoordinate
    let stationStatus: String
}

struct StationCoordinate {
        let latitude: String
        let longitude: String
}

final class SearchViewController: UIViewController {
    //TODO: 추후 userdefaults 변수로 변경 필요
    let searchHistorys: [StationInfo] = [StationInfo(stationName: "강남", lineId: "2", stationStatus: "possible"),StationInfo(stationName: "신촌", lineId: "2", stationStatus: "possible")]
    lazy var searchTextFieldView = SearchTextfieldView()
    lazy var searchHistoryView = searchHistorys.isEmpty ? EmptyHistoryView() : SearchHistoryView(searchHistorys: searchHistorys)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextFieldView.searchTextfield.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    private func safeAreaTopInset() -> CGFloat? {
        if #available(iOS 15.0, *) {
            let topArea = UIApplication.shared.windows.first?.safeAreaInsets.top
            return topArea
        } else {
            return nil
        }
    }
    
    private func setDefaultNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func voiceButtonPressed(_ sender: UIButton) {
        VoiceRecognitionManager().startRecognition()
        print("음성 인식 기능")
    }
    
}

private extension SearchViewController {
    func configure() {
        searchTextFieldView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        searchTextFieldView.voiceRecognitionButton.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        searchTextFieldView.searchTextfield.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(searchTextFieldView)
        searchTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(searchHistoryView)
        searchHistoryView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(22)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        guard textField.text!.count < 10 else { return false }

        return true
    }

}
