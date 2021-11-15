import UIKit
import AVFoundation
import Speech

struct AudioInfo {
    let text: String
    let audio: URL
}

protocol RecordingViewDelegate {
    func audioInfo(audioInfo: AudioInfo)
}

class RecordingView: UIView, AVAudioRecorderDelegate, SFSpeechRecognizerDelegate {
    
    // MARK: - Properties
    
    public var delegate: RecordingViewDelegate?
    
    private var recorderSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    private var audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var task: SFSpeechRecognitionTask?
    
    public var numberOfRecords: Int = 0
    
    private let dialogueFrame: UIView = {
        let tf = UIView()
        tf.layer.borderWidth = 3
        tf.layer.borderColor = UIColor.systemGray.cgColor
        return tf
    }()
    
    private let dialogueTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .systemRed
        return tv
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    private var isStart = false
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapRecordButton() {
        isStart.toggle()
        
        if isStart {
            startSpeech()
            startRecording()
        } else {
            stopSpeech()
            stopRecording()
            
            guard let text = dialogueTextView.text else { return }
            delegate?.audioInfo(audioInfo: AudioInfo(text: text, audio: getDirectory(filename: "test")))
        }
    }
    
    @objc func didTapStartButton() {
        let fileName = getDirectory(filename: "test")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileName)
            audioPlayer?.volume = 20
            audioPlayer?.play()
        } catch {
            print("audioPlayer Error")
        }
    }
    
    // MARK: - Helper
    
    func configureUI() {
        
        addSubview(dialogueFrame)
        dialogueFrame.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 280)
        
        dialogueFrame.addSubview(startButton)
        startButton.anchor(bottom: dialogueFrame.bottomAnchor,
                           right: dialogueFrame.rightAnchor,
                           paddingBottom: 10,
                           paddingRight: 10)
        startButton.setDimensions(height: 60, width: 60)
        
        dialogueFrame.addSubview(dialogueTextView)
        dialogueTextView.anchor(top: dialogueFrame.topAnchor,
                                left: dialogueFrame.leftAnchor,
                                bottom: startButton.topAnchor,
                                right: dialogueFrame.rightAnchor,
                                paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        addSubview(recordButton)
        recordButton.anchor(bottom: bottomAnchor)
        recordButton.setDimensions(height: 60, width: 60)
        recordButton.centerX(inView: self)
    }
    
    func getDirectory(filename: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = documentDirectory.appendingPathComponent("\(filename).m4a")
        return fileName
    }
    
    func startSpeech() {
        speechRecognizer.delegate = self
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audio engine error")
        }
        
        guard let myRecognition = SFSpeechRecognizer() else { return }
        
        if !myRecognition.isAvailable {
            print("not available")
        }
        
        task = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { response, _ in
            guard let response = response else { return }
            let dialogue = response.bestTranscription.formattedString
            self.dialogueTextView.text = dialogue
        })
    }
    
    func startRecording() {
        let fileName = getDirectory(filename: "test")
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.delegate = self
            
            audioRecorder?.record()
            audioRecorder?.record()
            
            recordButton.backgroundColor = .systemYellow
        } catch {
            print("audioRecorder Error")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        recordButton.backgroundColor = .systemPink
    }
    
    func stopSpeech() {
        task?.finish()
        task?.cancel()
        task = nil
        
        recognitionRequest.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        print("authorized")
                    case .denied:
                        print("authorized")
                    case .restricted:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)

                    case .notDetermined:
                        self.recordButton.isEnabled = false
                        self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                default:
                    break
                }
            }
        }
    }
}
