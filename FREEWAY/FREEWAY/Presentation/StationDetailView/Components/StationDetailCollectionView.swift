//
//  StationDetailCollectionView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/30.
//

import UIKit
import SnapKit
import Then

final class StationDetailCollectionView: UIView {
    
    private let stationInfoItems: [(String, String)] = [("elevator", "엘리베이터"),("call", "안내전화"),("map", "역사지도"),("elevator", "편의시설")]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: StationDetailCollectionViewCell.stationDetailCollectionViewCellId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension StationDetailCollectionView {
    func setupLayout() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension StationDetailCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stationInfoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StationDetailCollectionViewCell.stationDetailCollectionViewCellId, for: indexPath) as? StationDetailCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(stationInfoItems[indexPath.row].0, stationInfoItems[indexPath.row].1)
        return cell
    }
}
