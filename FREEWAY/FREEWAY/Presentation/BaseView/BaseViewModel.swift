//
//  BaseViewModel.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/09/05.
//

import UIKit
import Then
import SnapKit
import RxSwift


class BaseViewModel {
    //TODO: 추후 네트워크 작업으로 변경될 부분
    var stationDatas = MockData.mockStationDTOs
    var stationDetailData = MockData.mockStationDetail
    
    init() {
        
    }
    
    struct Input { // View에서 발생할 Input 이벤트(Stream)들
        let trigger: Observable<String> // viewWillAppear와 같은 trigger event
    }
    struct Output { // NView에 반영시킬 Output Stream들
        let resultText: Observable<StationDTO> // UILabel 등에 바인딩할 데이터 Stream
    }
    var disposeBag = DisposeBag()
    
    //var currentText = BehaviorRelay(value: "")
    
    func getStationDTO(input: Input) -> Output {
        let currentText = input.trigger

        let resultObservable = currentText
            .map { text -> StationDTO? in
                //self.currentText = text
                return self.stationDatas.first { $0.stationName == text }
            }
            .filter { $0 != nil }
            .map { $0! } // Force unwrap since we've filtered out nil values

        return Output(resultText: resultObservable)
    }
}
