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
    var searchText = BehaviorRelay<String>(value: "")
    var voiceRecognizedText = BehaviorRelay<String?>(value: nil)

    // Input
    struct Input {
        let searchText: Driver<String>
        let voiceRecognizedText: Driver<String?>
    }

    // Output
    struct Output {
        let updatedText: Driver<String>
    }

    private let disposeBag = DisposeBag()

    init() {
        setupBindings()
    }

    func setupBindings() {
        let input = Input(
            searchText: searchText.asDriver(),
            voiceRecognizedText: voiceRecognizedText.asDriver()
        )

        let output = transform(input: input)

        // 출력(Output)을 처리할 Output 프로퍼티 추가
        viewModelOutput = output
    }

    func transform(input: Input) -> Output {
        // Combine searchText and voiceRecognizedText into a single updatedText
        let updatedText = Driver.combineLatest(input.searchText, input.voiceRecognizedText) { (search, voice) -> String in
            return voice ?? search
        }

        return Output(updatedText: updatedText)
    }
    
    // ViewModel Output 프로퍼티 추가
    var viewModelOutput: Output?
}
