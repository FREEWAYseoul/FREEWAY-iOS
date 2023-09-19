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
    let viewModel: BaseViewModel
    
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
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 9
        $0.distribution = .equalSpacing
    }
    
    lazy var lineButton = LineButton(viewModel.currentStationDetailData.lineId)

    lazy var subLineButtons = [LineButton]()
    
    func setSubLineButtons() {
        viewModel.currentStationDetailData.transferStations.forEach {
            let subLine = LineButton($0.lineId)
            subLineButtons.append(subLine)
        }
    }

    lazy var stationTitle = StationTitle(viewModel: viewModel)
    
    
    init(viewModel: BaseViewModel ) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setSubLineButtons()
        
        configure()
        setupSublineButtonsLayout()
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind() {
        resetStackView()
        let newTransferStations = viewModel.currentStationDetailData.transferStations
        lineButton = LineButton(viewModel.currentStationDetailData.lineId)
        lineButton.isCurrentLine = true
        lineButton.setContentHuggingPriority(.required, for: .horizontal)
        subLineButtons = newTransferStations.map { LineButton($0.lineId) }
        stackView.addArrangedSubview(lineButton)
        for subLineButton in subLineButtons {
            subLineButton.setContentHuggingPriority(.required, for: .horizontal)
            stackView.addArrangedSubview(subLineButton)
        }
        setupSublineButtonsLayout()
    }
    
    func resetStackView() {
        stackView.removeArrangedSubview(lineButton)
        lineButton.removeFromSuperview()
        for subLineButton in subLineButtons {
            stackView.removeArrangedSubview(subLineButton)
            subLineButton.removeFromSuperview()
        }
    }

}

private extension StationDetailTitleView {
    func configure() {
        lineButton.isCurrentLine = true
        lineButton.setContentHuggingPriority(.required, for: .horizontal)
        stackView.addArrangedSubview(lineButton)
        for subLineButton in subLineButtons {
            subLineButton.setContentHuggingPriority(.required, for: .horizontal)
            stackView.addArrangedSubview(subLineButton)
        }
    }
    
    func setupLayout() {
        //MARK: 제외된 부분
//        self.addSubview(backButton)
//        backButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(13)
//            make.trailing.equalToSuperview().offset(-24)
//            make.height.equalTo(21)
//        }
//
//        backButton.addSubview(closeButtonImage)
//        closeButtonImage.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        closeButtonImage.isUserInteractionEnabled = false
        
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
        }
        
        self.addSubview(stationTitle)
        stationTitle.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(14.5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setupSublineButtonsLayout() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(21)
        }
    }
}

final class LineButton: UIButton {
    var line: String = "" {
        didSet {
            lineLabel.text = setLineText(line)
        }
    }
    
    var isCurrentLine: Bool = false {
        didSet {
            lineBackground.backgroundColor = self.isCurrentLine ? LinePallete(rawValue: self.line)?.color : .white
            lineLabel.textColor = self.isCurrentLine ? .white : LinePallete(rawValue: line)?.color
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
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
        $0.text = setLineText(line)
        $0.textColor = LinePallete(rawValue: line)?.color
        $0.sizeToFit()
    }
    
    init(_ line: String, _ isCurrentLine: Bool = false) {
        self.isCurrentLine = isCurrentLine
        self.line = line
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLineText(_ line: String) -> String {
        switch line {
        case "D1":
            return "신분당"
        case "K1":
            return "수인분당"
        case "K4":
            return "경의중앙"
        default :
            return line
        }
    }
}

private extension LineButton {
    func setupLayout() {
        self.addSubview(lineBackground)
        lineBackground.snp.makeConstraints { make in
            make.height.equalTo(20)
            if line.count > 1 {
                make.width.equalTo(lineLabel.intrinsicContentSize.width + 12)
                print(lineLabel.intrinsicContentSize.width)
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
        $0.font = UIFont(name: "Pretendard-Regular", size: 15)
        $0.text = stationName
        $0.textColor = .white
        $0.textAlignment = .right
        $0.sizeToFit()
    }
    
    let emptyLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 15)
        $0.text = "다음역 없음"
        $0.textColor = .white
        $0.sizeToFit()
        $0.layer.opacity = 0.5
    }
    
    private let nextImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
}

private extension NextStationButton {
    func setupLayout() {
        if stationName != "" {
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
        else {
            self.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.top.height.equalToSuperview()
                make.trailing.equalToSuperview().offset(-8)
                make.centerY.equalToSuperview()
                //make.width.equalTo(54)
            }
            emptyLabel.isUserInteractionEnabled = false
        }

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
        $0.font = UIFont(name: "Pretendard-Regular", size: 15)
        $0.text = stationName
        $0.textColor = .white
        $0.sizeToFit()
    }
    
    let emptyLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard-Regular", size: 15)
        $0.text = "이전역 없음"
        $0.textColor = .white
        $0.sizeToFit()
        $0.layer.opacity = 0.5
    }
    
    private let prevImage = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.left")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
}

private extension PrevStationButton {
    func setupLayout() {
        if stationName != "" {
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
        } else {
            self.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.top.height.equalToSuperview()
                make.leading.equalToSuperview().offset(8)
                make.centerY.equalToSuperview()
                //make.width.equalTo(54)
            }
            emptyLabel.isUserInteractionEnabled = false
        }
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
        $0.clipsToBounds = true
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
    
    
    
    init(viewModel: BaseViewModel) {
        let data = viewModel.currentStationDetailData
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
    
    func bind() {
        
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
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        prevNextStationTitlebackground.addSubview(nextStationTitleButton)
        nextStationTitleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        
        self.addSubview(stationTitleBackground)
        stationTitleBackground.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(prevNextStationTitlebackground)
            //텍스트 길이에 따라 옵셔널로 들어가야할 부분
            if stationLabel.text!.count <= 5 { make.width.equalTo(stationLabel.intrinsicContentSize.width + lineImage.intrinsicContentSize.width + 62) }
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
            if stationLabel.text!.count > 6 { make.width.equalTo(120) }
        }
    }
}
