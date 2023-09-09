//
//  BaseViewModel.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/05.
//
import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    var stationDatas = MockData.mockStationDTOs
    var stationsDetailDatas: [StationDetailDTO]?
    var currentStationData = MockData.mockStationDTO
    var currentStationDetailData = MockData.mockStationDetail
    
    // 입력된 데이터를 저장하는 BehaviorSubject
    let inputText = BehaviorSubject<String>(value: "")
    let inputVoice = BehaviorSubject<String?>(value: "듣고 있어요")
    let disposeBag = DisposeBag()
    // Observable로 변환하여 ViewController에서 사용할 수 있도록
    var stationName: Observable<String> {
        return inputText.asObservable()
    }
    
    var voiceStationName: Observable<String?> {
        return inputVoice.asObservable()
    }
    
    // 사용자 입력을 업데이트하는 함수
    func updateText(_ text: String) {
        inputText.onNext(text)
    }
    
    func updateVoiceText(_ text: String) {
        inputText.onNext(text)
        inputVoice.onNext(text)
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

    // StationName을 기반으로 StationDetailDTO 반환
//    func getStationDetailDTO() -> StationDetailDTO? {
//        do {
//            let stationId = currentStationData?.stationId
//            if let stationDetailData = stationDetailDatas.first(where: { $0.stationName == stationName }) {
//                return stationDetailData
//            }
//            return nil
//        } catch {
//            return nil
//        }
//    }
}
