//
//  VoiceRecognitionManager.swift
//  FREEWAY
//
//  Created by 한택환 on 2023/08/27.
//

import AVFoundation
import Speech
import RxSwift

protocol VoiceRecognitionDelegate: AnyObject {
    func didRecognizeVoice(text: String)
}

class VoiceRecognitionManager: NSObject, SFSpeechRecognizerDelegate {
    weak var delegate: VoiceRecognitionDelegate?
    
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        speechRecognizer?.delegate = self
    }
    
    func startRecognition() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            return
        }
        
        request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let request = request else {
            return
        }
        
        let inputNode = audioEngine.inputNode
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                let recognizedText = result.bestTranscription.formattedString
                if isFinal {
                    self.delegate?.didRecognizeVoice(text: recognizedText)
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.request = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine start error: \(error)")
        }
    }
    
    func stopRecognition() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
}

