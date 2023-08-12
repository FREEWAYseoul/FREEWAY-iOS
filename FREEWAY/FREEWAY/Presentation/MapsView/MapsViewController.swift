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
    
    private lazy var mapsView = NMFMapView().then {
        $0.allowsZooming = true
        $0.logoInteractionEnabled = false
        $0.allowsScrolling = true
        locationOverlay = $0.locationOverlay
    }
    
    let stationMarker = NMFMarker().then {
        $0.position = NMGLatLng(lat: 37.496, lng: 127.028)
        $0.iconImage = NMFOverlayImage(name: "GangnamStation")
        $0.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        $0.height = CGFloat(NMF_MARKER_SIZE_AUTO)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configurecurrentLocation()
    }
}

//MARK: SetMapsViewComponent
private extension MapsViewController {
    
    func configurecurrentLocation() {
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
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
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
    }
    
    func setupLayout() {
        self.view.addSubview(mapsView)
        mapsView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    //TODO: 현재 위치 테스트 구문
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            setcurrentLocation()
            setStationMarker()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
        case .denied:
            print("GPS 권한 요청 거부됨")
        default:
            print("GPS: Default")
        }
    }
}

