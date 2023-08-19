//
//  StationMarkerView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/17.
//

import UIKit
import SnapKit
import Then

final class StationMarkerView: UIView {
    var lineImageName: String
    var stationColor: UIColor
    var stationName: String
    
    private lazy var stationMarkerBackground = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = MapsLiteral.markerRadius
        $0.layer.borderWidth = MapsLiteral.markerBorderWidth
        $0.layer.borderColor = stationColor.cgColor
    }
    
    private lazy var lineImage = UIImageView().then {
        $0.image = UIImage(named: lineImageName)
    }
    private lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 18)
        $0.text = stationName
        $0.textColor = .black
    }
    
    override func setNeedsDisplay(_ rect: CGRect) {

        // Draw balloon shape
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2 + 10, y: 10))
        path.addLine(to: CGPoint(x: rect.width / 2 - 10, y: 10))
        path.close()

        stationColor.setFill() // 배경 색상 설정
        path.fill()
    }
    
    init(lineImageName: String, stationColor: UIColor, stationName: String) {
        self.lineImageName = lineImageName
        self.stationColor = stationColor
        self.stationName = stationName
        super.init(frame: .zero)
        
        configure()
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StationMarkerView {
    private func configure() {
        print("hi")
        self.addSubview(stationMarkerBackground)
         self.addSubview(lineImage)
         self.addSubview(stationLabel)
     }
     
     private func setupLayout() {
         stationMarkerBackground.snp.makeConstraints { make in
             make.width.equalTo(88)
             make.height.equalTo(34)
             make.center.equalToSuperview()
         }
         
         lineImage.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalToSuperview().offset(6)
             // 이미지 크기 설정 등 필요한 제약 추가
         }
         
         stationLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.trailing.equalToSuperview().offset(-9)
         }
     }
}
