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
    var data: StationDetailDTO
    
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
    
    lazy var lineButton = LineButton(data.lineId)

    lazy var subLineButtons = [SubLineButton]()
    
    func setSubLineButtons() {
        data.transferStations.forEach {
            let subLine = SubLineButton($0.lineId)
            subLineButtons.append(subLine)
        }
    }

    lazy var stationTitle = StationTitle(data: data)
    
    
    init(data: StationDetailDTO) {
        self.data = data
        super.init(frame: .zero)
        self.setSubLineButtons()
        
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
    }
    
    func setupLayout() {
        self.addSubview(lineButton)
        lineButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(21)
            make.width.equalTo(lineButton.lineIcon.intrinsicContentSize.width)
        }
        
        var prevSubLine: SubLineButton?
        
        for idx in 0..<subLineButtons.count {
            let subLineButton = subLineButtons[idx]
            self.addSubview(subLineButton)
            
            subLineButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(13)
                if idx == 0 {
                    make.leading.equalTo(lineButton.snp.trailing).offset(9)
                }
                else {
                    make.leading.equalTo(prevSubLine!.snp.trailing).offset(9)
                }
                make.height.equalTo(21)
                make.width.equalTo(subLineButton.intrinsicContentSize.width)
            }
            
            prevSubLine = subLineButton
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
            make.top.equalTo(lineButton.snp.bottom).offset(12)
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
    
    var line: String = "" {
        didSet {
            lineIcon.image = UIImage(named: self.line)
        }
    }
    
    lazy var lineIcon = UIImageView().then {
        $0.image = UIImage(named: line)
        $0.contentMode = .scaleAspectFit
        $0.sizeToFit()
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

final class SubLineButton: UIButton {
    var line: String = "" {
        didSet {
            lineLabel.text = line
        }
    }
    
    private lazy var lineBackground = UIView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = LinePallete(rawValue: self.line)?.color?.cgColor
    }
    private lazy var lineLabel = UILabel().then {
        $0.text = line
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.textColor = LinePallete(rawValue: line)?.color
        $0.sizeToFit()
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

private extension SubLineButton {
    func setupLayout() {
        self.addSubview(lineBackground)
        lineBackground.snp.makeConstraints { make in
            make.height.equalTo(20)
            if line.count > 1 {
                make.width.equalTo(lineLabel.intrinsicContentSize.width + 12)
            }
            else {
                make.width.equalTo(20)
            }
        }
        lineBackground.isUserInteractionEnabled = false
        
        lineBackground.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

final class NextStationButton: UIButton {
    var stationName: String
    
    init(_ stationName: String) {
        self.stationName = stationName
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.text = stationName
        $0.textColor = .white
        $0.textAlignment = .right
    }
    
    private let nextImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
}

private extension NextStationButton {
    func setupLayout() {
        self.addSubview(nextImage)
        nextImage.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        nextImage.isUserInteractionEnabled = false
        
        self.addSubview(stationLabel)
        stationLabel.snp.makeConstraints { make in
            make.top.height.equalToSuperview()
            make.trailing.equalTo(nextImage.snp.leading).offset(-5)
            make.width.equalTo(54)
        }
        stationLabel.isUserInteractionEnabled = false

    }
}

final class PrevStationButton: UIButton {
    var stationName: String
    
    init(_ stationName: String) {
        self.stationName = stationName
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.text = stationName
        $0.textColor = .white
    }
    
    private let prevImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.left")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
}

private extension PrevStationButton {
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
    }
}


final class StationTitle: UIView {
    var lineImageName: String = "" {
        didSet {
            stationTitleBackground.layer.borderColor = LinePallete(rawValue: self.lineImageName)?.color?.cgColor
            prevNextStationTitlebackground.backgroundColor = LinePallete(rawValue: self.lineImageName)?.color
            lineImage.image = UIImage(named: self.lineImageName)
        }
    }
    var stationName: String
    var nextStationName: String?
    var prevStationName: String?
    
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
    lazy var stationLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 18)
        $0.text = stationName
        $0.textColor = .black
        $0.sizeToFit()
        $0.lineBreakMode = .byTruncatingTail
    }
    private lazy var prevNextStationTitlebackground = UIView().then {
        $0.backgroundColor = LinePallete(rawValue: lineImageName)?.color
        $0.layer.cornerRadius = 14
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 2
        $0.distribution = .fillProportionally
    }
    
    lazy var prevStationTitleButton = PrevStationButton(prevStationName ?? "")
    lazy var nextStationTitleButton = NextStationButton(nextStationName ?? "")
    
    
    
    init(data: StationDetailDTO) {
        self.lineImageName = data.lineId
        self.stationName = data.stationName
        self.nextStationName = data.nextStation?.stationName
        self.prevStationName = data.previousStation?.stationName
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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        prevNextStationTitlebackground.addSubview(nextStationTitleButton)
        nextStationTitleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(stationTitleBackground)
        stationTitleBackground.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(prevNextStationTitlebackground)
            //텍스트 길이에 따라 옵셔널로 들어가야할 부분
            if stationLabel.text!.count <= 5 {make.width.equalTo(stationLabel.intrinsicContentSize.width + lineImage.intrinsicContentSize.width + 62) }
            else { make.width.equalTo(150) }
            make.height.equalTo(39.9)
            make.center.equalToSuperview()
        }

        stackView.addArrangedSubview(lineImage)
        stackView.addArrangedSubview(stationLabel)

        stationTitleBackground.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            if stationLabel.text!.count > 5 { make.width.equalTo(120) }
        }
    }
}
