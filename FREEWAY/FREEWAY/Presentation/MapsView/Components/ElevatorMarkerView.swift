//
//  ElevatorMarkerView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/29.
//

import UIKit
import SnapKit
import Then

final class ElevatorMarker: UIView {
    var imageName: String
    var stationColor: UIColor
    var stationName: String
    var fontSize: CGFloat
    
    private lazy var stationMarkerBackground = UIView().then {
        $0.backgroundColor = stationColor
        $0.layer.cornerRadius = 15
    }
    
    private lazy var lineImage = UIImageView().then {
        $0.image = UIImage(named: imageName)
        $0.contentMode = .scaleAspectFit
    }
    private lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-SemiBold", size: fontSize)
        $0.text = stationName
        $0.textColor = .white
    }
    
    override func draw(_ rect: CGRect) {

        // Draw balloon shape
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2 - 3.25, y: 30))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 39.4))
        path.addLine(to: CGPoint(x: rect.width / 2 + 3.25, y: 30))
        path.close()

        stationColor.setFill() // 배경 색상 설정
        path.fill()
    }
    
    init(imageName: String, stationColor: UIColor, stationName: String, fontSize: CGFloat) {
        self.imageName = imageName
        self.stationColor = stationColor
        self.stationName = stationName
        self.fontSize = fontSize
        super.init(frame: .zero)
        
        configure()
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ElevatorMarker {
    private func configure() {
        self.addSubview(stationMarkerBackground)
         self.addSubview(lineImage)
         self.addSubview(stationLabel)
     }
     
     private func setupLayout() {
         stationMarkerBackground.snp.makeConstraints { make in
             make.width.equalToSuperview()
             make.height.equalTo(30)
             make.center.equalToSuperview()
         }
         
         lineImage.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             //TODO: 향후 뷰에 추가되면서 수정될 부분
             make.leading.equalToSuperview().offset(5)
             make.width.height.equalTo(20)
         }
         
         stationLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.leading.equalTo(lineImage.snp.trailing).offset(5)
         }
     }
}
