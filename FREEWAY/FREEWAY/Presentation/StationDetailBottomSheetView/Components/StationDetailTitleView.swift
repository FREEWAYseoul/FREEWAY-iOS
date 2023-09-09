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
    var lineImageName: String
    var stationColor: UIColor
    var stationName: String
    var prevStationName: String
    var nextStationName: String
    
    private let closeButtonImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "xmark")
        $0.tintColor = Pallete.customGray.color
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var backButton = UIButton(frame: .zero).then {
        $0.backgroundColor = .clear
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = Pallete.dividerGray.color
    }
    
    var lineButtons: [LineButton] = [LineButton("2"), LineButton("K2")]
    
    var lineButtonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 9
    }
    
    lazy var stationTitle = StationTitle(lineImageName: lineImageName, stationColor: stationColor, stationName: stationName, nextStationName: nextStationName, prevStationName: prevStationName)
    
    
    init(lineImageName: String, stationColor: UIColor, stationName: String, nextStationName: String, prevStationName: String) {
        self.lineImageName = lineImageName
        self.stationColor = stationColor
        self.stationName = stationName
        self.nextStationName = nextStationName
        self.prevStationName = prevStationName
        super.init(frame: .zero)
        
        configure()
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StationDetailTitleView {
    func configure() {
        for lineButton in lineButtons {
            lineButtonsStackView.addArrangedSubview(lineButton)
        }
    }
    
    func setupLayout() {
        self.addSubview(lineButtonsStackView)
        lineButtonsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(21)
        }
        
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(21)
        }
        
        backButton.addSubview(closeButtonImage)
        closeButtonImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(lineButtonsStackView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(stationTitle)
        stationTitle.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(14.5)
            make.leading.trailing.equalToSuperview()
        }
    }
}

final class LineButton: UIButton {
    
    var line: String
    
    lazy var lineIcon = UIImageView().then {
        $0.image = UIImage(named: line)
        $0.contentMode = .scaleAspectFit
    }
    
    init(_ line: String) {
        self.line = line
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LineButton {
    func setupLayout() {
        self.addSubview(lineIcon)
        lineIcon.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        lineIcon.isUserInteractionEnabled = false
    }
}

final class PrevNextStationButton: UIButton {
    var stationName: String
    var isPrev: Bool
    
    init(_ stationName: String, _ isPrev: Bool) {
        self.stationName = stationName
        self.isPrev = isPrev
        super.init(frame: .zero)
        if isPrev {
            nextImage.isHidden = true
        } else {
            prevImage.isHidden = true
        }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.text = stationName
        $0.textColor = .white
    }
    
    private let prevImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.left")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private let nextImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
}

private extension PrevNextStationButton {
    func setupLayout() {
            self.addSubview(prevImage)
            prevImage.snp.makeConstraints { make in
                make.height.equalTo(18)
                make.leading.equalToSuperview().offset(8)
                make.centerY.equalToSuperview()
            }
            prevImage.isUserInteractionEnabled = false
        
        self.addSubview(stationLabel)
        stationLabel.snp.makeConstraints { make in
            make.top.height.equalToSuperview()
            make.leading.equalTo(prevImage.snp.trailing).offset(5)
            make.width.equalTo(54)
        }
        stationLabel.isUserInteractionEnabled = false
            
            stationLabel.snp.updateConstraints { make in
                make.leading.equalTo(prevImage.snp.trailing).offset(5)
            }
            self.addSubview(nextImage)
            nextImage.snp.makeConstraints { make in
                make.height.equalTo(18)
                make.leading.equalTo(stationLabel.snp.trailing).offset(5)
                make.centerY.equalToSuperview()
            }
            nextImage.isUserInteractionEnabled = false
    }
}

final class StationTitle: UIView {
    var lineImageName: String
    var stationName: String
    var nextStationName: String
    var prevStationName: String
    
    private lazy var stationTitleBackground = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 39 / 2
        $0.layer.borderWidth = 3.15
        $0.layer.borderColor = LinePallete(rawValue: lineImageName)?.color?.cgColor
    }
    
    private lazy var lineImage = UIImageView().then {
        $0.image = UIImage(named: lineImageName)
        $0.contentMode = .scaleAspectFit
    }
    private lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 18)
        $0.text = stationName
        $0.textColor = .black
        $0.sizeToFit()
    }
    private lazy var prevNextStationTitlebackground = UIView().then {
        $0.backgroundColor = LinePallete(rawValue: lineImageName)?.color
        $0.layer.cornerRadius = 14
    }
    lazy var prevStationTitleButton = PrevNextStationButton(prevStationName, true)
    lazy var nextStationTitleButton = PrevNextStationButton(nextStationName, false)
    
    
    
    init(lineImageName: String, stationColor: UIColor, stationName: String, nextStationName: String, prevStationName: String) {
        self.lineImageName = lineImageName
        self.stationName = stationName
        self.nextStationName = nextStationName
        self.prevStationName = prevStationName
        super.init(frame: .zero)
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension StationTitle {
    
    private func setupLayout() {
        self.addSubview(prevNextStationTitlebackground)
        prevNextStationTitlebackground.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(28)
        }
        
        prevNextStationTitlebackground.addSubview(prevStationTitleButton)
        prevStationTitleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        prevNextStationTitlebackground.addSubview(nextStationTitleButton)
        nextStationTitleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-78)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(stationTitleBackground)
        stationTitleBackground.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(prevNextStationTitlebackground)
            //텍스트 길이에 따라 옵셔널로 들어가야할 부분
            make.width.equalTo(stationLabel.intrinsicContentSize.width)
            make.height.equalTo(39.9)
            make.center.equalToSuperview()
        }
        stationTitleBackground.addSubview(lineImage)
        lineImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12.68)
            make.width.height.equalTo(20)
        }
        stationTitleBackground.addSubview(stationLabel)
        stationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lineImage.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-12.68)
        }
    }
}
