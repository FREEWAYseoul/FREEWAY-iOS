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
    static let shared = VoiceRecognitionManager()
    
    weak var delegate: VoiceRecognitionDelegate?
    
    var isRecognizing = false
    var resultText: String?
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var audioRecorder: AVAudioRecorder?
    private let silenceThreshold: TimeInterval = 5.0 // 1초간 무응답인 경우 자동 종료
    
    private override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR")) //한국어
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
        isRecognizing = true
        
        let inputNode = audioEngine.inputNode
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                self.resultText = result.bestTranscription.formattedString
                if isFinal {
                    self.delegate?.didRecognizeVoice(text: self.resultText ?? "")
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
            startRecordingSilenceDetection()
        } catch {
            print("Audio Engine start error: \(error)")
        }
    }
    
    func stopRecognition() {
        isRecognizing = false
        audioEngine.stop()
        recognitionTask?.cancel()
        stopRecordingSilenceDetection()
    }
    
    private func startRecordingSilenceDetection() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record)
            try audioSession.setActive(true)
            
            let audioURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("silence.caf")
            let audioSettings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatAppleIMA4),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderBitRateKey: 12800,
                AVLinearPCMBitDepthKey: 16,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: audioSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + silenceThreshold) { [weak self] in
                self?.stopRecognition()
            }
        } catch {
            print("Error starting audio recorder: \(error)")
        }
    }
    
    private func stopRecordingSilenceDetection() {
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error stopping audio recorder: \(error)")
        }
        audioRecorder = nil
    }
}

extension VoiceRecognitionManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            let averagePower = recorder.averagePower(forChannel: 0)
            if averagePower < -30.0 { // Assuming -30 dB as silence threshold
                stopRecognition()
            } else {
                startRecordingSilenceDetection()
            }
        } else {
            print("Audio recording failed.")
        }
    }
}
