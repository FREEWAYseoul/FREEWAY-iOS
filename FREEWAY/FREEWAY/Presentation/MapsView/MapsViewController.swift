//
//  MapsViewController.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/04.
//

import UIKit
import NMapsMap
import Then
import SnapKit
import CoreLocation
import RxSwift
import RxCocoa
import Combine

struct StationMarker {
    let stationData: StationDTO
    let markerImage: NMFMarker
}

class MapsViewController: UIViewController {
    
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    let networkService = NetworkService.shared
    private var cancelBag = Set<AnyCancellable>()
    
    private var currentLocation: CLLocationManager!
    private var locationOverlay: NMFLocationOverlay?
    private var data = MockData.mockStationDTOs.first

    let bottomSheetVC = BottomSheetViewController(isTouchPassable: true)
    var bottomSheetHiddenState = false
    
    private var currentLocationButton = CurrentLocationButton()
    private lazy var mapsView = NMFMapView().then {
        $0.allowsZooming = true
        $0.logoInteractionEnabled = false
        $0.allowsScrolling = true
        $0.minZoomLevel = 14
        locationOverlay = $0.locationOverlay
    }
    private let mapsTitleView = MapsViewTitle()
    
    private var facilitiesView: FacilitiesView?
    private var stationMapWebView: StationMapWebView?
    
    private lazy var stationMarkers: [StationMarker] = []
    private var currentStationMarker: NMFMarker?
    private var elevatorMarkers: [NMFMarker] = []
    
    lazy var stationDetailView = StationDetailViewController(self.viewModel.currentStationDetailData)
    
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        data = viewModel.currentStationData
        viewModel.getCurrentStationDetailData(stationData: data!)
        var searchHistorys = UserDefaults.standard.searchHistory
        searchHistorys.insert(viewModel.currentStationData.stationId, at: 0)
        searchHistorys = Array(Set(searchHistorys))
        UserDefaults.standard.searchHistory = searchHistorys
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        currentLocation = CLLocationManager()
        configure()
        setupLayout()
        configureCurrentLocation()
        setStationMarker()
        setStationDetailMarker()
        setElevatorMarker()
        setDefaultNavigationBar()
        showBottomSheet()
        bind()
    }
    
    //MARK: Contraints
    private func safeAreaTopInset() -> CGFloat? {
        if #available(iOS 15.0, *) {
            let topArea = UIApplication.shared.windows.first?.safeAreaInsets.top
            return topArea
        } else {
            return nil
        }
    }
    
    private func setDefaultNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: Action
    @objc func closeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func titleLabelPressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func currentLocationButtonDidTap() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            let alert = UIAlertController(title: "현재 위치 설정", message: "현재 위치를 찾기 위해서 권한이 필요해요.\n설정에서 위치 권한을 허용해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let settingAction = UIAlertAction(title: "설정", style: .default) {  _ in
                
                let settingsURLScheme = "App-Prefs:"
                
                if let url = URL(string: settingsURLScheme) {
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    } else {
                        // 해당 URL을 열 수 없는 경우 처리
                        print("설정 창을 열 수 없습니다.")
                    }
                } else {
                    // 잘못된 URL 처리
                    print("잘못된 URL입니다.")
                }
            }
            alert.addAction(okAction)
            alert.addAction(settingAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else {
            setcurrentLocation()
        }
    }
}
//MARK: Set MapsView
private extension MapsViewController {
    
    func bind() {
        stationDetailView.setPrevButtonPublisher.withRetained(self)
            .sink { [self] `self`, id in
                setStationDetailView(id)
            }.store(in: &cancelBag)
        
        stationDetailView.setNextButtonPublisher.withRetained(self)
            .sink { [self] `self`, id in
                setStationDetailView(id)
            }.store(in: &cancelBag)
    }
    
    func setStationDetailView(_ id: Int) {
        self.data = viewModel.getStationDTOWithId(id: id)
        viewModel.getCurrentStationDetailData(stationData: self.data!)
        stationDetailView.data = viewModel.currentStationDetailData
        stationDetailView.stationDetailTitle.stationTitle.stationLabel.text = viewModel.currentStationDetailData.stationName
        stationDetailView.stationDetailTitle.stationTitle.prevStationTitleButton.stationLabel.text = stationDetailView.data.previousStation?.stationName
        stationDetailView.stationDetailTitle.stationTitle.nextStationTitleButton.stationLabel.text = stationDetailView.data.nextStation?.stationName
        stationDetailView.stationDetailTitle.stationTitle.lineImageName = viewModel.currentStationDetailData.lineId
        stationDetailView.stationDetailTitle.lineButton.line = viewModel.currentStationDetailData.lineId
        facilitiesView = FacilitiesView((viewModel.currentStationDetailData.facilities ?? MockData.mockStationDetail.facilities)!)
        stationMapWebView = StationMapWebView(data: viewModel.currentStationDetailData)
        self.deleteStationDetailMarker()
        self.moveLocation()
        self.setElevatorMarker()
        self.setStationDetailMarker()
        self.deleteBottomSheet()
        self.showBottomSheet()
    }
    
    func configure() {
        mapsTitleView.currentTextLabel.text = viewModel.currentStationData.stationName
        mapsView.addCameraDelegate(delegate: self)
        mapsView.touchDelegate = self
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonDidTap), for: .touchUpInside)
        mapsTitleView.closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        mapsTitleView.backButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        let textLabelGesture = UITapGestureRecognizer(target: self, action: #selector(titleLabelPressed))
        mapsTitleView.currentTextLabel.addGestureRecognizer(textLabelGesture)
        
    }
    
    func setupLayout() {
        self.view.addSubview(mapsView)
        mapsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(mapsTitleView)
        mapsTitleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(59)
        }
        
        self.view.addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.17)
            make.bottom.equalTo(-260)
            make.height.width.equalTo(36.67)
        }
    }
    func setupStationDetailViewLayout(_ subView: UIView) {
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.top.equalTo(mapsTitleView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
}

//MARK: SetMarker
private extension MapsViewController {
    func createMarkerImage(imageView: UIView, position: CLLocationCoordinate2D) -> NMFMarker {
        let markerView = NMFMarker().then {
            $0.position = NMGLatLng(lat: position.latitude, lng: position.longitude)
            $0.iconImage = NMFOverlayImage(image: imageView.toImage()!)
            $0.width = imageView.frame.width
            $0.height = imageView.frame.height
        }
        return markerView
    }
    
    func addMarker(data: StationDTO, width: CGFloat, height: CGFloat) {
        let imageView = StationMarkerView(
            elevatorCount: String(data.availableElevatorsNumber), stationName: data.stationName, line: data.lineId
        )
        let position: CLLocationCoordinate2D = {
            CLLocationCoordinate2D(latitude: CLLocationDegrees(data.coordinate.latitude)!, longitude: CLLocationDegrees(data.coordinate.longitude)!)
        }()
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.stationLabel.intrinsicContentSize.width + 40, height: height)
        
        let stationMarker: StationMarker = StationMarker(stationData: data, markerImage: createMarkerImage(imageView: imageView, position: position))
        stationMarkers.append(stationMarker)
    }
    
    func addDetailMarker(width: CGFloat, height: CGFloat) -> NMFMarker {
        let imageView = CurrentStationMarkerView(lineImageName: self.data!.lineId, stationName: self.data!.stationName)
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.stationLabel.intrinsicContentSize.width + imageView.lineImage.intrinsicContentSize.width + 27.3, height: height)
        let position: CLLocationCoordinate2D = {
            CLLocationCoordinate2D(latitude: CLLocationDegrees(self.data!.coordinate.latitude)!, longitude: CLLocationDegrees(self.data!.coordinate.longitude)!)
        }()
        return createMarkerImage(imageView: imageView, position: position)
    }
    
    func addElevatorMarker(data: Elevator, width: CGFloat, height: CGFloat) {
        let imageView = ElevatorMarkerView(exitNumber: data.exitNumber, status: data.elevatorStatus)
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        let position: CLLocationCoordinate2D = {
            CLLocationCoordinate2D(latitude: CLLocationDegrees(data.elevatorCoordinate.latitude)!, longitude: CLLocationDegrees(data.elevatorCoordinate.longitude)!)
        }()
        elevatorMarkers.append(createMarkerImage(imageView: imageView, position: position))
    }
    
    func setElevatorMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.viewModel.currentStationDetailData.elevators!.forEach {
                    self.addElevatorMarker(data: $0, width: 100, height: 39.74)
                }
                self.elevatorMarkers.forEach {
                    $0.mapView = self.mapsView
                    $0.globalZIndex = 19000
                }
            }
        }
    }
    
    func setStationMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.viewModel.stationDatas.forEach {
                    self.addMarker(data: $0, width: 72, height: 39.74)
                }
                self.stationMarkers.forEach { stationMarker in
                    let markerImage = stationMarker.markerImage
                    markerImage.mapView = self.mapsView
                    markerImage.touchHandler = { (overlay: NMFOverlay) -> Bool in
                        self.deleteStationDetailMarker()
                        self.mapsView.zoomLevel = 17
                        self.viewModel.updateText(stationMarker.stationData.stationName)
                        self.setStationDetailView(stationMarker.stationData.stationId)
                        return true
                    }
                }
            }
        }
    }
    
    func deleteStationDetailMarker() {
        currentStationMarker?.mapView = nil
        elevatorMarkers.forEach {
            $0.mapView = nil
        }
        elevatorMarkers.removeAll()
    }
    
    func setStationDetailMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.currentStationMarker = self.addDetailMarker(width: 94.5, height: 49.3)
                self.currentStationMarker?.mapView = self.mapsView
                self.currentStationMarker?.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    return true
                }
            }
        }
    }
}

//MARK: SetMapsViewComponent
private extension MapsViewController {
    
    func configureCurrentLocation() {
        currentLocation.delegate = self
        currentLocation.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation.requestWhenInUseAuthorization()
    }
    
    func moveLocation() {
        guard let latitudeString = data?.coordinate.latitude,
              let longitudeString = data?.coordinate.longitude,
              let latitude = CLLocationDegrees(latitudeString),
              let longitude = CLLocationDegrees(longitudeString) else {
            // 값이 없는 경우 강남역의 위치로 설정
            let gangnamStationLocation = NMGLatLng(lat: 37.498085, lng: 127.027548)
            let cameraUpdate = NMFCameraUpdate(scrollTo: gangnamStationLocation, zoomTo: 17)
            cameraUpdate.animation = .easeIn
            mapsView.moveCamera(cameraUpdate)
            return
        }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 17)
        cameraUpdate.animation = .easeIn
        mapsView.moveCamera(cameraUpdate)
        bottomSheetVC.move(to: .half, animated: true)
    }
    
    func setcurrentLocation() {
        let latitude = currentLocation.location?.coordinate.latitude ?? 0
        let longitude = currentLocation.location?.coordinate.longitude ?? 0
        
        if CLLocationManager.locationServicesEnabled() {
            //TODO: 테스트 구문
            print("위치 서비스 On 상태")
            currentLocation.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 17)
            cameraUpdate.animation = .easeIn
            mapsView.moveCamera(cameraUpdate)
            guard let locationOverlay = locationOverlay else { return }
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
            locationOverlay.circleOutlineWidth = 10
        }
    }
}

//MARK: SetBottomSheet
private extension MapsViewController {
    func showBottomSheet() {
        stationDetailView.delegate = self
        bottomSheetVC.set(contentViewController: stationDetailView)
        bottomSheetVC.addPanel(toParent: self)
        bottomSheetVC.show()
        facilitiesView = FacilitiesView((viewModel.currentStationDetailData.facilities ?? MockData.mockStationDetail.facilities)!)
        stationMapWebView = StationMapWebView(data: viewModel.currentStationDetailData)
    }
    
    func deleteBottomSheet() {
        bottomSheetVC.removeFromParent()
    }
}

extension MapsViewController: SetStationDetailViewControllerDelegate {
    func removeStationDetailView() {
        if let stationMapWebView = stationMapWebView {
            stationMapWebView.removeFromSuperview()
        }
        if let facilitiesView = facilitiesView {
            facilitiesView.removeFromSuperview()
        }
    }
    
    func showStationDetailView(_ isFacilities: Bool) {
        if isFacilities {
            if let subView = facilitiesView {
                stationMapWebView?.removeFromSuperview()
                setupStationDetailViewLayout(subView)
                view.insertSubview(subView, at: view.subviews.count - 2)
            }
        } else {
            if let subView = stationMapWebView {
                facilitiesView?.removeFromSuperview()
                setupStationDetailViewLayout(subView)
                view.insertSubview(subView, at: view.subviews.count - 2)
            }
        }

    }
}

//MARK: MapsViewDelegate
extension MapsViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        bottomSheetVC.move(to: .tip, animated: true)
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if mapView.zoomLevel >= 13 {
            currentStationMarker?.hidden = false
            elevatorMarkers.forEach {
                $0.hidden = false
            }
        } else {
            currentStationMarker?.hidden = true
            elevatorMarkers.forEach {
                $0.hidden = true
            }
        }
    }
}

extension MapsViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if bottomSheetHiddenState == true {
            bottomSheetVC.move(to: .half, animated: true)
            bottomSheetHiddenState = false
        } else {
            bottomSheetHiddenState = true
            bottomSheetVC.move(to: .hidden, animated : true)
        }
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    //TODO: 현재 위치 테스트 구문
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async { [weak self] in
                if let self = self {
                    self.moveLocation()
                }
            }
            
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
}
