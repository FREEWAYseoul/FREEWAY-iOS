//
//  BaseViewModel.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/05.
//
import Foundation
import RxSwift
import RxCocoa
import Combine

class BaseViewModel {
    //MARK: 네트워크 작업 후에 받아오는 데이터
    var stationDatas: [StationDTO] = []
    var stationsDetailDatas: [StationDetailDTO] = []
    var notificationDatas: [NotificationDTO] = []
    
    var currentStationData = MockData.mockStationDTO
    var currentStationDetailData = MockData.mockStationDetail
    
    // 입력된 데이터를 저장하는 BehaviorSubject
    let inputText = BehaviorSubject<String>(value: "")
    let inputVoice = PassthroughSubject<String, Never>()
    //TODO: MapsViewController의 ViewModel에 들어갈 부분
    let searchPublisher = PassthroughSubject<String, Never>()
    let inputTextPublisher = PassthroughSubject<String, Never>()
    let disposeBag = DisposeBag()
    // 사용자 입력을 업데이트하는 함수
    func updateText(_ text: String? = nil) {
        inputText.onNext(text ?? currentStationDetailData.stationName)
    }
    
    func getStationName() -> String? {
        do {
            let stationName = try inputText.value()
            return stationName
        } catch {
            // BehaviorSubject에서 값을 가져오지 못한 경우
            return nil
        }
    }
    
    func getStationDTO() -> StationDTO? {
        do {
            let stationName = try inputText.value()
            // StationName을 사용하여 StationDTO를 검색하고 반환
            if let station = stationDatas.first(where: { $0.stationName == stationName }) {
                self.currentStationData = station
                return station
            }
            return nil // 찾을 수 없는 경우
        } catch {
            // BehaviorSubject에서 값을 가져오지 못한 경우
            return nil
        }
    }
    
    func getStationDTOWithId(id: Int) -> StationDTO? {
        do {
            // StationName을 사용하여 StationDTO를 검색하고 반환
            if let station = stationDatas.first(where: { $0.stationId == id }) {
                self.currentStationData = station
                return station
            }
            return nil // 찾을 수 없는 경우
        } catch {
            // BehaviorSubject에서 값을 가져오지 못한 경우
            return nil
        }
    }
    
    func getCurrentStationDetailData(stationData: StationDTO) {
        currentStationDetailData = (stationsDetailDatas.first{ $0.stationId == stationData.stationId}) ?? MockData.mockStationDetail
    }
    
    func hasNewerDate() -> Bool {
        let lastVisitDate = UserDefaults.standard.lastVisitDate
        if let newestNotificationDate = notificationDatas.first?.date.formatStringToDate() {
            return lastVisitDate == nil || newestNotificationDate > lastVisitDate!
        }
        return lastVisitDate == nil
    }
}
