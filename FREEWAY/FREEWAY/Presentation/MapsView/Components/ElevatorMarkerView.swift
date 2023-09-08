//
//  ElevatorMarkerView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/09.
//

import UIKit
import SnapKit
import Then

final class ElevatorMarkerView: UIView {
    var imageName: String
    var exitNumber: String
    var status: String
    
    private lazy var stationMarkerBackground = UIView().then {
        $0.backgroundColor = Pallete(rawValue: status)?.color
        $0.layer.cornerRadius = MapsLiteral.markerRadius
    }
    
    lazy var elevatorImage = UIImageView().then {
        $0.image = UIImage(named: imageName)
        $0.contentMode = .scaleAspectFit
        $0.sizeToFit()
    }
    lazy var exitLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 15)
        $0.text = exitNumber
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    override func draw(_ rect: CGRect) {

        // Draw balloon shape
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2 - 3.25, y: 30))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 39.74))
        path.addLine(to: CGPoint(x: rect.width / 2 + 3.25, y: 39.74))
        path.close()

        Pallete(rawValue: status)?.color?.setFill() // 배경 색상 설정
        path.fill()
    }
    
    init(imageName: String, exitNumber: String, status: String) {
        self.imageName = imageName
        self.status = status
        self.exitNumber = exitNumber
        super.init(frame: .zero)
        
        configure()
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ElevatorMarkerView {
    private func configure() {
        self.addSubview(stationMarkerBackground)
         self.addSubview(elevatorImage)
         self.addSubview(exitLabel)
     }
     
     private func setupLayout() {
         stationMarkerBackground.snp.makeConstraints { make in
             make.width.equalTo(exitLabel.intrinsicContentSize.width + 47)
             make.height.equalTo(30)
             make.center.equalToSuperview()
         }
         
         elevatorImage.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalToSuperview().offset(12)
             make.height.equalTo(18)
         }
         
         exitLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalTo(elevatorImage.snp.trailing).offset(5)
         }
     }
}

