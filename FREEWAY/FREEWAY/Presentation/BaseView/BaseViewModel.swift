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
    // 입력된 데이터를 저장하는 BehaviorSubject
    let textSubject = BehaviorSubject<String>(value: "")
    
    // Observable로 변환하여 ViewController에서 사용할 수 있도록
    var textObservable: Observable<String> {
        return textSubject.asObservable()
    }
    
    // 사용자 입력을 업데이트하는 함수
    func updateText(_ text: String) {
        textSubject.onNext(text)
    }
}
