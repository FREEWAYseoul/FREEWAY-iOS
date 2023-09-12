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

final class SearchViewController: UIViewController {
    
    private let voiceRecognitionManager = VoiceRecognitionManager.shared
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    var datas = MockData.mockStationDTOs
    let networkService = NetworkService.shared
    
    //TODO: 추후 userdefaults 변수로 변경 필요
    lazy var searchTextFieldView = SearchTextfieldView()
    lazy var searchHistoryView = SearchHistoryView(viewModel: viewModel)
    private let emptyHistoryView = EmptyHistoryView()
    lazy var voiceSearchLottieView = VoiceSearchLottieView()
    lazy var searchListView = SearchListView(datas: viewModel.stationDatas)
    lazy var emptySearchView = EmptyView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistoryView.searchHistoryTableView.reloadData()
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
        searchHistoryView.isHidden = true
        searchListView.isHidden = true
        setupLottieLayout()
        voiceSearchLottieView.voiceLottieView.play()
        voiceSearchLottieView.voiceLottieView.loopMode = .loop //무한 반복
        voiceRecognitionManager.startRecognition()
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.searchListView.isHidden = false
        self.searchHistoryView.isHidden = false
        self.voiceRecognitionManager.stopRecognition()
        self.voiceSearchLottieView.removeFromSuperview()
        self.navigateToMapsViewControllerIfNeeded(self.viewModel.getStationName() ?? "강남")
        }
    }
    
    private func bind() {
        viewModel.voiceStationName
            .subscribe(onNext: { [weak self] text in
                self?.voiceSearchLottieView.resultTextLabel.text = text
            })
            .disposed(by: disposeBag)
        
        searchTextFieldView.searchTextfield.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.handleTextFieldInput(text)
                self?.emptySearchView.searchText = text
            })
            .disposed(by: disposeBag)
        
        searchTextFieldView.searchTextfield.rx.text.orEmpty
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
    }
    
    func handleTextFieldInput(_ text: String) {
        if !text.isEmpty {
            searchListView.datas = self.viewModel.stationDatas.filter{ $0.stationName.hasPrefix(text) }
            setupSearchListLayout(view: searchListView.datas.isEmpty ? emptySearchView : searchListView)
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
        searchHistoryView.searchHistoryTableView.delegate = self
        searchHistoryView.isHidden = UserDefaults.standard.searchHistory.isEmpty
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
        
        if searchHistoryView.isHidden {
            view.addSubview(emptySearchView)
            emptySearchView.snp.makeConstraints { make in
                make.top.equalTo(searchTextFieldView.snp.bottom).offset(22)
                make.bottom.leading.trailing.equalToSuperview()
            }
        } else {
            emptySearchView.removeFromSuperview()
        }
    }
    
    func setupLottieLayout() {
        view.addSubview(voiceSearchLottieView)
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
        return viewModel.stationDatas.first { $0.stationName == stationName }
    }
    
    private func showInvalidStationNameAlert() {
        let alert = UIAlertController(title: "역 이름을 다시 한 번 확인해주세요!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMapsViewControllerIfNeeded(_ searchText: String) {
        if findStationDetailDTO(searchText) != nil {
            viewModel.currentStationData = viewModel.getStationDTO()!
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
                self.navigationController?.pushViewController(MapsViewController(viewModel: viewModel), animated: true)
            }
            else {
                showInvalidStationNameAlert()
            }
        }
    }
}
