//
//  StationDetailTitleView.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/30.
//

import UIKit
import SnapKit
import Then

final class StationDetailTitleView: UIView {
    private let closeButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "xmark")
        $0.tintColor = Pallete.customGray.color
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
}

final class lineButton: UIButton {
    
    var line: String
    
    lazy var lineIcon = UIImageView().then {
        $0.image = UIImage(named: line)
        $0.contentMode = .scaleAspectFit
    }
    
    init(_ line: String) {
        self.line = line
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension lineButton {
    func setupLayout() {
        self.addSubview(lineIcon)
        lineIcon.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
}

final class StationTitle: UIView {
    var lineImageName: String
    var stationColor: UIColor
    var stationName: String
    
    private lazy var stationTitleBackground = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = self.frame.height / 2
        $0.layer.borderWidth = 3.15
        $0.layer.borderColor = LinePallete.two.color?.cgColor
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
    private let prevNextStationTitlebackground = UIView().then {
        $0.backgroundColor = LinePallete.two.color
        $0.layer.cornerRadius = 14
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


private extension StationTitle {
    private func configure() {
        self.addSubview(prevNextStationTitlebackground)
        self.addSubview(stationTitleBackground)
        self.addSubview(lineImage)
        self.addSubview(stationLabel)
    }
    
    private func setupLayout() {
        prevNextStationTitlebackground.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(28)
        }
        
        stationTitleBackground.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(prevNextStationTitlebackground)
            //텍스트 길이에 따라 옵셔널로 들어가야할 부분
            make.width.equalTo(94.5)
            make.height.equalTo(39.9)
            make.center.equalToSuperview()
        }
        
        lineImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(29)
            make.width.height.equalTo(20)
        }
        
        stationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lineImage.snp.trailing).offset(2)
        }
    }
}
