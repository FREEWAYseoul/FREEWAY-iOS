//
//  StationDetailViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/30.
//

import UIKit
import SnapKit
import Then

protocol SetStationDetailViewControllerDelegate: AnyObject {
    func showStationDetailView(_ isFacilities: Bool)
}

final class StationDetailViewController: UIViewController {
    
    weak var delegate: SetStationDetailViewControllerDelegate?
    
    var data = MockData.mockStationDetail
    private let stationInfoItems: [(String, String)] = [("elevater", "엘리베이터"),("call", "안내전화"),("map", "역사지도"),("convenience", "편의시설")]
    
    let stationDetailCollectionView = StationDetailCollectionView()
    lazy var stationDetailTitle = StationDetailTitleView(lineImageName: data.lineId, stationColor: (LinePallete(rawValue: data.lineId)?.color!)!, stationName: data.stationName, nextStationName: data.nextStation.stationName, prevStationName: data.previousStation.stationName)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupLayout()
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
        print("안녕")
        return stationInfoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationDetailCollectionViewCell.stationDetailCollectionViewCellId, for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(stationInfoItems[indexPath.row].0, stationInfoItems[indexPath.row].1)
        return cell
    }
}

extension StationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) is StationDetailCollectionViewCell {
            
            let selectedItem = stationInfoItems[indexPath.row].0
            switch selectedItem {
            case "elevater":
                print("elevator")
            case "call":
                let url = "tel://\(data.stationContact)"
                 
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
