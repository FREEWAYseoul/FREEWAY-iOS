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

struct StationMarker {
    let stationData: StationDTO
    let markerImage: NMFMarker
}

class MapsViewController: UIViewController {
    
    let viewModel: BaseViewModel
    let disposeBag = DisposeBag()
    
    private var currentLocation: CLLocationManager!
    private var locationOverlay: NMFLocationOverlay?
    private var data = MockData.mockStationDTOs.first
    
    private lazy var bottomSheet = StationDetailViewController(viewModel.getStationDetailDTO()!)
    private var bottomSheetState = false
    
    private var currentLocationButton = CurrentLocationButton()
    private lazy var mapsView = NMFMapView().then {
        $0.allowsZooming = true
        $0.logoInteractionEnabled = false
        $0.allowsScrolling = true
        locationOverlay = $0.locationOverlay
    }
    private let mapsTitleView = MapsViewTitle()
    
    private lazy var facilitiesView = FacilitiesView(viewModel.getStationDetailDTO()!)
    private var stationMapWebView = StationMapWebView()
    
    private lazy var stationMarkers: [StationMarker] = []
    private var currentStationMarker: NMFMarker?
    
    init(viewModel: BaseViewModel) {
        self.viewModel = viewModel
        data = viewModel.getStationDTO()
        print(data)
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
        setDefaultNavigationBar()
        showBottomSheet()
        bind()
    }
    
    private func bind() {
        viewModel.stationName
            .subscribe(onNext: { [weak self] text in
                self?.mapsTitleView.currentTextLabel.text = text
            })
            .disposed(by: disposeBag)
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
    
    func configure() {
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
            $0.width = CGFloat(72)
            $0.height = CGFloat(39.74)
        }
        return markerView
    }
    
    func addMarker(data: StationDTO, width: CGFloat, height: CGFloat) {
        let imageView = StationMarkerView(
            line: data.lineId,
            stationName: data.stationName
        )
        let position: CLLocationCoordinate2D = {
            CLLocationCoordinate2D(latitude: CLLocationDegrees(data.coordinate.latitude)!, longitude: CLLocationDegrees(data.coordinate.longitude)!)
        }()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
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
    
    func addElevatorMarker(data: ElevatorDTO, width: CGFloat, height: CGFloat) -> NMFMarker {
        let imageView = ElevatorMarkerView(imageName: "", exitNumber: "", status: "")
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.exitLabel.intrinsicContentSize.width + 47, height: height)
        let position: CLLocationCoordinate2D = {
            CLLocationCoordinate2D(latitude: CLLocationDegrees(self.data!.coordinate.latitude)!, longitude: CLLocationDegrees(self.data!.coordinate.longitude)!)
        }()
        return createMarkerImage(imageView: imageView, position: position)
    }
    
    func setStationMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.viewModel.stationDatas.forEach {
                    self.addMarker(data: $0, width: 72, height: 39.7)
                }
                self.stationMarkers.forEach { stationMarker in
                    let markerImage = stationMarker.markerImage
                    print(markerImage)
                    markerImage.mapView = self.mapsView
                    markerImage.touchHandler = { (overlay: NMFOverlay) -> Bool in
                        self.deleteStationDetailMarker()
                        self.mapsView.zoomLevel = 14
                        self.viewModel.updateText(stationMarker.stationData.stationName)
                        self.data = self.viewModel.getStationDTO()
                        //현재 좌표로 확대하도록 변경되어야할 부분
                        self.moveLocation()
                        self.setStationDetailMarker()
                        return true
                    }
                }
            }
        }
    }
    
    func deleteStationDetailMarker() {
        currentStationMarker?.mapView = nil
    }
    
    func setStationDetailMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.currentStationMarker = self.addDetailMarker(width: 94.5, height: 49.3)
                self.currentStationMarker?.mapView = self.mapsView
                self.currentStationMarker?.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    self.bottomSheetState ? self.hideBottomSheet() : self.showBottomSheet()
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
            let cameraUpdate = NMFCameraUpdate(scrollTo: gangnamStationLocation, zoomTo: 14)
            cameraUpdate.animation = .easeIn
            mapsView.moveCamera(cameraUpdate)
            return
        }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
        cameraUpdate.animation = .easeIn
        mapsView.moveCamera(cameraUpdate)
    }
    
    func setcurrentLocation() {
        let latitude = currentLocation.location?.coordinate.latitude ?? 0
        let longitude = currentLocation.location?.coordinate.longitude ?? 0
        
        if CLLocationManager.locationServicesEnabled() {
            //TODO: 테스트 구문
            print("위치 서비스 On 상태")
            currentLocation.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
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
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { fatalError() }
        let bottomSheetHeight = (scene.screen.bounds.height - 233)
        self.addChild(bottomSheet)
        view.addSubview(bottomSheet.view)
        bottomSheet.delegate = self
        bottomSheet.didMove(toParent: self)
        bottomSheet.view.frame = CGRect(x: 0, y: scene.screen.bounds.height, width: scene.screen.bounds.width, height: 233)
        bottomSheet.view.layer.cornerRadius = 20
        bottomSheet.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheet.view.layer.masksToBounds = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomSheet.view.frame.origin.y = bottomSheetHeight
        }
        bottomSheetState = true
    }
    
    func hideBottomSheet() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { fatalError() }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.bottomSheet.view.frame.origin.y = scene.screen.bounds.height
        }) { [weak self] _ in
            self?.bottomSheet.view.willMove(toWindow: nil)
            self?.bottomSheet.view.removeFromSuperview()
            self?.bottomSheet.removeFromParent()
        }
        bottomSheetState = false
    }
}

extension MapsViewController: SetStationDetailViewControllerDelegate {
    func removeStationDetailView() {
        stationMapWebView.removeFromSuperview()
        facilitiesView.removeFromSuperview()
    }
    
    func showStationDetailView(_ isFacilities: Bool) {
        let subView = isFacilities ? facilitiesView : stationMapWebView
        if subView == facilitiesView {
            stationMapWebView.removeFromSuperview()
        } else { facilitiesView.removeFromSuperview() }
        setupStationDetailViewLayout(subView)
        view.insertSubview(subView, at: view.subviews.count - 2)
    }
}

//MARK: MapsViewDelegate
extension MapsViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if mapView.zoomLevel >= 13 {
            currentStationMarker?.hidden = false
            print("축소됨")
        } else {
            currentStationMarker?.hidden = true
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    }
}

extension MapsViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if bottomSheetState { self.hideBottomSheet() }
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
