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
    struct Input {
        let text: Observable<String>
    }
    
    struct Output {
        let result: Observable<String>
        let currentStation: Observable<StationDetailDTO>
    }
    
    let disposeBag = DisposeBag()
    
    // BehaviorSubject를 사용하여 현재 StationDetailDTO를 저장
    private let currentStationSubject = BehaviorSubject<StationDetailDTO?>(value: nil)
    
    var currentStation: Observable<StationDetailDTO> {
        return currentStationSubject
            .compactMap { $0 } // nil이 아닌 값만 방출
    }
    
    init() {

    }
    
    func transform(input: Input) -> Output {
        let rxResult = input.text.asObservable()
        
        // 예제를 위해 더미 StationDetailDTO를 생성
        let dummyStationDetailDTO = MockData.mockStationDetail
        
        // 입력 텍스트가 변경될 때마다 현재 StationDetailDTO 업데이트
        let resultObservable = rxResult
            .map { text -> StationDTO? in
                //self.currentText = text
                return MockData.mockStationDTOs.first { $0.stationName == text }
            }
            .filter { $0 != nil }
            .map { $0! } // Force unwrap since we've filtered out nil values
        print(resultObservable)
        return Output(result: rxResult, currentStation: currentStation)
    }
}
