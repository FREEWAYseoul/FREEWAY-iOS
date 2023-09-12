//
//  VoiceRecognitionManager.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//


import AVFoundation
import Speech
import RxSwift
import RxCocoa

protocol VoiceRecognitionDelegate: AnyObject {
    func didRecognizeVoice(text: String)
    func voiceRecognitionError(error: Error)
}

class VoiceRecognitionManager: NSObject, SFSpeechRecognizerDelegate {
    var viewModel: BaseViewModel?
    static let shared = VoiceRecognitionManager()
    
    weak var delegate: VoiceRecognitionDelegate?
    
    var isRecognizing = false
    var resultText: String?
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR")) // 한국어
        speechRecognizer?.delegate = self
    }
    
    func setViewModel(viewModel: BaseViewModel) {
        self.viewModel = viewModel
    }
    
    func startRecognition() {
        guard !isRecognizing, let recognizer = speechRecognizer, recognizer.isAvailable else {
            return
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let request = request else {
            return
        }
        isRecognizing = true
        resultText = nil
        
        let inputNode = audioEngine.inputNode
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                self.resultText = result.bestTranscription.formattedString
                self.viewModel?.updateVoiceText(self.resultText ?? "듣고 있어요")
                self.viewModel?.updateText(self.resultText)
                self.delegate?.didRecognizeVoice(text: self.resultText ?? "")
            }
            if error != nil || result?.isFinal == true {
                self.stopRecognition()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.stopRecognition()
            }
        } catch {
            print("Audio Engine start error: \(error)")
            delegate?.voiceRecognitionError(error: error)
            stopRecognition()
        }
    }
    
    func stopRecognition() {
        if isRecognizing {
            isRecognizing = false
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            request?.endAudio()
            recognitionTask?.cancel()
            recognitionTask = nil
            request = nil
            self.viewModel?.updateVoiceText("듣고 있어요")
        }
    }
}
