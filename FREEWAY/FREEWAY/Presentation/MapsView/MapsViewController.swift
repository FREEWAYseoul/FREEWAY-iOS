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

class MapsViewController: UIViewController {
    private var currentLocation: CLLocationManager!
    private var locationOverlay: NMFLocationOverlay?
    //TODO: 임시 강남역 마커로 설정 추후 배열로 변경 예정
    private var stationMarkerView = StationMarkerView(lineImageName: "two", stationColor: .green, stationName: "강남역").then {
        $0.frame = CGRect(x: 0, y: 0, width: 94.5, height: 49.3)
    }
    
    private lazy var bottomSheet = StationDetailViewController()
    private var bottomSheetState = false
    
    private var currentLocationButton = CurrentLocationButton()
    
    private lazy var mapsView = NMFMapView().then {
        $0.allowsZooming = true
        $0.logoInteractionEnabled = false
        $0.allowsScrolling = true
        locationOverlay = $0.locationOverlay
    }
    
    private lazy var stationMarker = NMFMarker().then {
        //TODO: 임시 position 변수 후에 API 연결 시 변경 예정
        //TODO: 임시 marker icon 후에 UIView로 구현 예정
        $0.position = NMGLatLng(lat: 37.496, lng: 127.028)
        
        $0.iconImage = NMFOverlayImage(image: self.stationMarkerView.toImage()!)
        $0.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        $0.height = CGFloat(NMF_MARKER_SIZE_AUTO)
    }
    
    private let searchTextFieldView = SearchTextfieldView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        currentLocation = CLLocationManager()
        configure()
        setupLayout()
        configureCurrentLocation()
        setStationMarker()
    }
    
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
    
    @objc func closeButtonPressed(_ sender: UIButton) {
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
        searchTextFieldView.voiceRecognitionButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        searchTextFieldView.backButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        searchTextFieldView.voiceRecognitionImage.image = UIImage(systemName: "x.circle.fill")
        searchTextFieldView.voiceRecognitionImage.tintColor = Pallete.customGray.color
    }
    
    func setupLayout() {
        self.view.addSubview(mapsView)
        mapsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((safeAreaTopInset() ?? 50) + 13)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(searchTextFieldView)
        searchTextFieldView.snp.makeConstraints { make in
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
}

//MARK: SetMapsViewComponent
private extension MapsViewController {
    
    func configureCurrentLocation() {
        currentLocation.delegate = self
        currentLocation.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation.requestWhenInUseAuthorization()
    }
    
    func setcurrentLocation() {
        let latitude = currentLocation.location?.coordinate.latitude ?? 0
        let longitude = currentLocation.location?.coordinate.longitude ?? 0
        
        if CLLocationManager.locationServicesEnabled() {
            //TODO: 테스트 구문
            print("위치 서비스 On 상태")
            currentLocation.startUpdatingLocation()
            print(latitude, longitude)
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 14)
            cameraUpdate.animation = .easeIn
            mapsView.moveCamera(cameraUpdate)
            guard let locationOverlay = locationOverlay else { return }
            locationOverlay.hidden = false
            locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
            locationOverlay.circleOutlineWidth = 10
            
        } else {
            //TODO: 테스트 구문
            //위치 서비스가 Off일 시에 예외처리가 필요 -> 앱 내 Alert 띄워주고 터치해서 위치 정보 접근 허용으로 이동하는 알림이면 좋을 듯
            print("위치 서비스 Off 상태")
        }
    }
    
    func setStationMarker() {
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                self.stationMarker.mapView = self.mapsView
                self.stationMarker.touchHandler = { (overlay: NMFOverlay ) -> Bool in
                    self.bottomSheetState ? self.hideBottomSheet() : self.showBottomSheet()
                    return true
                }
            }
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


//MARK: MapsViewDelegate
extension MapsViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        
        //TODO: 현재 zoom 정도에 따라서 stationMarker를 표시할지 말지에 대한 로직 추후 논의 필요
        //        if mapView.zoomLevel >= MapsLiteral.markerZoomLevel {
        //            stationMarker.hidden = false
        //        } else {
        //            stationMarker.hidden = true
        //        }
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
                    self.setcurrentLocation()
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
