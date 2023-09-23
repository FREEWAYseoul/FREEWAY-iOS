//
//  SearchViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Combine

final class SearchViewController: UIViewController {
    
    private let voiceRecognitionManager = VoiceRecognitionManager.shared
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    private var cancelBag = Set<AnyCancellable>()
    var datas = MockData.mockStationDTOs
    let networkService = NetworkService.shared
    
    lazy var searchTextFieldView = SearchTextfieldView()
    lazy var voiceSearchLottieView = VoiceSearchLottieView()
    lazy var searchListView = SearchListView(datas: viewModel.stationDatas)
    lazy var emptySearchView = EmptyView()
    lazy var searchListViewModule = SearchListViewController(viewModel: self.viewModel)
    private lazy var mapsViewController = MapsViewController(viewModel: self.viewModel)
    
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
        setDefaultNavigationBar()
        configure()
        setupLayout()
        voiceRecognitionManager.setViewModel(viewModel: viewModel)
        bind()
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
        searchListViewModule.view.isHidden = true
        setupLottieLayout()
        voiceSearchLottieView.voiceLottieView.play()
        searchTextFieldView.voiceImage = "waveform"
        voiceSearchLottieView.voiceLottieView.loopMode = .loop //무한 반복
        voiceRecognitionManager.startRecognition()
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.searchListViewModule.view.isHidden = false
        self.voiceRecognitionManager.stopRecognition()
        self.searchTextFieldView.voiceImage = "mic.fill"
        self.voiceSearchLottieView.removeFromSuperview()
        self.navigateToMapsViewControllerIfNeeded(self.viewModel.getStationName() ?? "강남")
        }
    }
    
    private func bind() {
        viewModel.inputVoice.withRetained(self)
            .sink { `self`, resultText in
                self.voiceSearchLottieView.resultTextLabel.text = resultText
            }.store(in: &cancelBag)
        
        searchTextFieldView.searchTextfield.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.handleTextFieldInput(text)
                self?.emptySearchView.searchText = text
            })
            .disposed(by: disposeBag)
        
        searchTextFieldView.searchTextfield.rx.text.orEmpty
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
        
        viewModel.searchPublisher.withRetained(self)
            .sink { `self`, currentStationName in
                self.viewModel.updateText(currentStationName)
                self.searchTextFieldView.searchText = currentStationName
            }.store(in: &cancelBag)
    }
    
    func handleTextFieldInput(_ text: String) {
        if !text.isEmpty {
            let filteredStations = self.viewModel.stationDatas.filter { station in
                let stationName = station.stationName
                if text.hasSuffix("역") {
                    let trimmedText = String(text.dropLast())
                    return stationName.hasPrefix(trimmedText)
                } else {
                    return stationName.hasPrefix(text)
                }
            }
            searchListView.datas = filteredStations
            setupSearchListLayout(view: filteredStations.isEmpty ? emptySearchView : searchListView)
            searchListView.searchHistoryTableView.reloadData()
        } else {
            searchListView.removeFromSuperview()
            emptySearchView.removeFromSuperview()
        }
    }
}

private extension SearchViewController {
    func configure() {
        searchTextFieldView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        searchTextFieldView.voiceRecognitionButton.addTarget(self, action: #selector(voiceButtonPressed), for: .touchUpInside)
        searchTextFieldView.searchTextfield.delegate = self
        searchListView.searchHistoryTableView.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(searchTextFieldView)
        searchTextFieldView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
        }
        
        self.addChild(searchListViewModule)
        view.addSubview(searchListViewModule.view)
        searchListViewModule.didMove(toParent: self)
        searchListViewModule.view.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(22)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupLottieLayout() {
        view.addSubview(voiceSearchLottieView)
        voiceSearchLottieView.resultTextLabel.text = "듣고 있어요"
        voiceSearchLottieView.snp.makeConstraints { make in
            make.top.equalTo(searchTextFieldView.snp.bottom).offset(91)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupSearchListLayout(view: UIView) {
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
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
    
    private func findStationDetailDTO(_ stationName: String) -> StationDTO? {
        var stationName = stationName
            if stationName.hasSuffix("역") {
                stationName = String(stationName.dropLast())
            }
        return viewModel.stationDatas.first { $0.stationName == stationName }
    }
    
    private func showInvalidStationNameAlert() {
        let alert = UIAlertController(title: "역 이름을 다시 한 번 확인해주세요!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMapsViewControllerIfNeeded(_ searchText: String) {
        if let currentStation = findStationDetailDTO(searchText) {
            viewModel.currentStationData = currentStation
            viewModel.getCurrentStationDetailData(stationData: viewModel.currentStationData)
            self.navigationController?.pushViewController(MapsViewController(viewModel: viewModel), animated: true)
        } else {
            showInvalidStationNameAlert()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            navigateToMapsViewControllerIfNeeded(searchText)
        }
        return true
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? SearchHistoryBaseViewCell {
            if let cellData = cell.cellData {
                viewModel.currentStationData = cellData
                viewModel.updateText(cellData.stationName)
                self.navigationController?.pushViewController(mapsViewController, animated: true)
            }
            else {
                showInvalidStationNameAlert()
            }
        }
    }
}
