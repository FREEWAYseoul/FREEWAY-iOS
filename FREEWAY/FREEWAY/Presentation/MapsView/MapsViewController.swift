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
    private var currentLocation = CLLocationManager()
    private var locationOverlay: NMFLocationOverlay?
    //TODO: 임시 강남역 마커로 설정 추후 배열로 변경 예정
    private var stationMarkerView = StationMarkerView(lineImageName: "two", stationColor: .green, stationName: "강남역").then {
        $0.frame = CGRect(x: 0, y: 0, width: 88, height: 50.5)
    }
    
    private lazy var bottomSheet = UIView().then {
        $0.backgroundColor = .lightGray
    }
    private var bottomSheetState = false
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configure()
        configureCurrentLocation()
    }
}
//MARK: Set MapsView
private extension MapsViewController {
    func configure() {
        mapsView.addCameraDelegate(delegate: self)
        mapsView.touchDelegate = self
    }
    
    func setupLayout() {
        self.view.addSubview(mapsView)
        mapsView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
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
        stationMarker.mapView = mapsView
        stationMarker.touchHandler = { (overlay: NMFOverlay ) -> Bool in
            self.bottomSheetState ? self.hideBottomSheet() : self.showBottomSheet()
            return true
        }
    }
}

//MARK: SetBottomSheet
private extension MapsViewController {
    func showBottomSheet() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { fatalError() }
        let bottomSheetHeight = (scene.screen.bounds.height - 233)
        bottomSheet.frame = CGRect(x: 0, y: scene.screen.bounds.height, width: scene.screen.bounds.width, height: 233)
        view.addSubview(bottomSheet)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomSheet.frame.origin.y = bottomSheetHeight
        }
        bottomSheetState = true
    }
    
    func hideBottomSheet() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { fatalError() }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.bottomSheet.frame.origin.y = scene.screen.bounds.height
        }) { [weak self] _ in
            self?.bottomSheet.removeFromSuperview()
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
                    self.setStationMarker()
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
