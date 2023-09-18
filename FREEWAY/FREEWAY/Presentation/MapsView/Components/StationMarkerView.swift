//
//  StationMarkerView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/29.
//

import UIKit
import SnapKit
import Then

final class StationMarkerView: UIView {
    var line: String
    var elevatorCount: String
    var stationColor: UIColor
    var stationName: String
    
    private lazy var stationMarkerBackground = UIView().then {
        $0.backgroundColor = stationColor
        $0.layer.cornerRadius = 15
    }
    
    private let lineBackground = UIView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
    }
    private lazy var lineLabel = UILabel().then {
        $0.text = elevatorCount != "-1" ? elevatorCount : "-"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.text = stationName
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    override func draw(_ rect: CGRect) {

        // Draw balloon shape
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2 - 3.25, y: 30))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 39.74))
        path.addLine(to: CGPoint(x: rect.width / 2 + 3.25, y: 30))
        path.close()

        stationColor.setFill() // 배경 색상 설정
        path.fill()
    }
    
    init(elevatorCount: String, stationName: String, line: String) {
        self.elevatorCount = elevatorCount
        self.line = line
        self.stationColor = (LinePallete(rawValue: line)?.color)!
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
         stationMarkerBackground.addSubview(lineBackground)
        lineBackground.addSubview(lineLabel)
         stationMarkerBackground.addSubview(stationLabel)
     }
     
     private func setupLayout() {
         stationMarkerBackground.snp.makeConstraints { make in
             make.width.equalTo(stationLabel.intrinsicContentSize.width + 40)
             make.height.equalTo(30)
             make.center.equalToSuperview()
         }
         
         lineBackground.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalToSuperview().offset(5)
             make.width.height.equalTo(20)
         }
         
         lineLabel.snp.makeConstraints { make in
             make.centerX.centerY.equalToSuperview()
         }
         
         stationLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalTo(lineBackground.snp.trailing).offset(5)
             make.trailing.equalToSuperview().offset(-10)
         }
     }
}
