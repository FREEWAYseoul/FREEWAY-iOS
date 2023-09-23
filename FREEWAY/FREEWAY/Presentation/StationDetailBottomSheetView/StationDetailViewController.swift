//
//  StationDetailViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/30.
//

import UIKit
import SnapKit
import Then
import Combine


protocol SetStationDetailViewControllerDelegate: AnyObject {
    func showStationDetailView(_ isFacilities: Bool)
    func removeStationDetailView()
}

final class StationDetailViewController: UIViewController {
    
    weak var delegate: SetStationDetailViewControllerDelegate?
    
    var viewModel: BaseViewModel
    private let stationInfoItems: [(String, String)] = [("elevater", "엘리베이터"),("call", "안내전화"),("map", "역사지도"),("convenience", "편의시설")]
    var setNextButtonPublisher = PassthroughSubject<Int, Never>()
    var setPrevButtonPublisher = PassthroughSubject<Int, Never>()
    
    let stationDetailCollectionView = StationDetailCollectionView()
    lazy var stationDetailTitle = StationDetailTitleView(viewModel: viewModel)

    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
        setAction()
    }
    
    func setAction() {
        stationDetailTitle.stationTitle.prevStationTitleButton.addTarget(self, action: #selector(prevStationButtonPressed), for: .touchUpInside)
        stationDetailTitle.stationTitle.nextStationTitleButton.addTarget(self, action: #selector(nextStationButtonPressed), for: .touchUpInside)
        
    }
    @objc func nextStationButtonPressed(_ sender: UIButton) {
        let id = viewModel.currentStationDetailData.nextStation?.stationId
        setNextButtonPublisher.send(id ?? viewModel.currentStationDetailData.stationId)
    }
    
    @objc func prevStationButtonPressed(_ sender: UIButton) {
        let id = viewModel.currentStationDetailData.previousStation?.stationId
        setPrevButtonPublisher.send(id ?? viewModel.currentStationDetailData.stationId)
        
    }
    
    @objc func subLineButtonPressed(_ sender: UIButton) {
        
        
    }
}

private extension StationDetailViewController {
    
    func configure() {
        view.backgroundColor = .white
        stationDetailCollectionView.collectionView.delegate = self
        stationDetailCollectionView.collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: StationDetailCollectionViewCell.stationDetailCollectionViewCellId)
        stationDetailCollectionView.collectionView.dataSource = self
        stationDetailCollectionView.collectionView.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(stationDetailTitle)
        stationDetailTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(124)
        }
        
        view.addSubview(stationDetailCollectionView)
        stationDetailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stationDetailTitle.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension StationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: 109)
    }
}


extension StationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stationInfoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationDetailCollectionViewCell.stationDetailCollectionViewCellId, for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(stationInfoItems[indexPath.row].0, stationInfoItems[indexPath.row].1)
        if indexPath.item == 0 {
          cell.isSelected = true
          collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        if indexPath.item == 1 && viewModel.currentStationDetailData.stationContact == nil {
            cell.unavailableButtonColor = Pallete.unavailableFacilitiesGray.color
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
}

extension StationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is StationDetailCollectionViewCell {
            let selectedItem = stationInfoItems[indexPath.row].0
            switch selectedItem {
            case "elevater":
                delegate?.removeStationDetailView()
            case "call":
                    var url = ""
                    delegate?.removeStationDetailView()
                if let number = viewModel.currentStationDetailData.stationContact {
                        print("안녕 ", number)
                        url = "tel://\(String(describing: number))"
                    }
                    
                    if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                        UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
                    }
            case "map":
                delegate?.showStationDetailView(false)
            case "convenience":
                delegate?.showStationDetailView(true)
            default:
                break
            }
        }
    }
}
