import UIKit
import AVFoundation

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var closebutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let titleView = TopCellContents()
    private let chatView = ChatView()
    
    private let titleFrame: CGRect
    private let topSafeAreaHeight: CGFloat
    
    private var audio: AVAudioPlayer?
    private var audioUrls: [URL]
    private var playNum = 0
    
    // MARK: - LifeCycel
    
    init(conversation: Conversation, cellFrame: CGRect, topSafeArea: CGFloat) {
        
        titleView.viewModal = TopViewModal(conversation: conversation, cellNumber: 0)
        titleFrame = cellFrame
        topSafeAreaHeight = topSafeArea
        chatView.conversation = conversation
        audioUrls = conversation.audioUrls.map { URL(string: $0)! }
        
        super.init(nibName: nil, bundle: nil)
        
        titleView.delegate = self
        configureUI()
        handleChatView(isShow: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        handleChatView(isShow: false)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemPink
        
        view.addSubview(titleView)
        titleView.frame = CGRect(x: titleFrame.origin.x,
                                 y: titleFrame.origin.y,
                                 width: titleFrame.width,
                                 height: titleFrame.height)
        
        view.addSubview(chatView)
        chatView.frame = CGRect(x: 0,
                                y: titleView.frame.origin.y + titleFrame.height,
                                width: view.frame.width,
                                height: view.frame.height - topSafeAreaHeight - titleView.frame.height)
        
        view.addSubview(closebutton)
        closebutton.frame = CGRect(x: view.frame.width - 70,
                                   y: topSafeAreaHeight,
                                   width: 60,
                                   height: 60)
    }
    
    func handleChatView(isShow: Bool) {
        
        UIView.animate(withDuration: 0.25) {
            self.titleView.frame.origin.y = isShow ? self.topSafeAreaHeight + 20 : self.titleFrame.origin.y
            self.titleView.backgroundColor = isShow ? .systemPink : .white
            self.titleView.membersView.collectionView.backgroundColor = isShow ? .systemPink : .white
            self.titleView.startButton.backgroundColor = isShow ? .systemBlue : .systemPink
            
            self.chatView.frame.origin.y = isShow ? self.titleView.frame.origin.y + self.titleFrame.height : self.view.frame.height
            self.closebutton.isHidden = isShow ? false : true
            
        } completion: { _ in
            if !isShow {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func prepareAudio(num: Int) -> Bool {
        
        if num < audioUrls.count {
            do {
                let data = try Data(contentsOf: audioUrls[playNum])
                audio = try AVAudioPlayer(data: data)
                audio?.volume = 20
                audio?.delegate = self
                
                return true
                
            } catch {
                print("audip Error")
            }
        }
        return false
    }
}

// MARK: - AVAudioPlayerDelegate

extension ChatViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNum += 1
        
        if prepareAudio(num: playNum) {
            audio?.play()
        }
    }
}

// MARK: - TopCellViewDelegate

extension ChatViewController: TopCellViewDelegate {
    
    func didTapStartButton(cell: TopCellContents) {
        if prepareAudio(num: playNum) {
            audio?.play()
        }
    }
}
