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
        $0.contentMode = .scaleAspectFit
    }
    private lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 18)
        $0.text = stationName
        $0.textColor = .black
    }
    
    override func draw(_ rect: CGRect) {

        // Draw balloon shape
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2 - 9, y: 40.3))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 49.3))
        path.addLine(to: CGPoint(x: rect.width / 2 + 9, y: 40.3))
        path.close()

        stationColor.setFill() // 배경 색상 설정
        path.fill()
    }
    
    init(lineImageName: String, stationName: String) {
        self.lineImageName = lineImageName
        self.stationColor = (LinePallete(rawValue: lineImageName)?.color)!
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
        self.addSubview(stationMarkerBackground)
         self.addSubview(lineImage)
         self.addSubview(stationLabel)
     }
     
     private func setupLayout() {
         stationMarkerBackground.snp.makeConstraints { make in
             make.width.equalTo(94.5)
             make.height.equalTo(40.3)
             make.center.equalToSuperview()
         }
         
         lineImage.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalToSuperview().offset(6)
             make.width.height.equalTo(20)
         }
         
         stationLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalTo(lineImage.snp.trailing).offset(6)
         }
     }
}
