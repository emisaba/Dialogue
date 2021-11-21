import UIKit
import AVFoundation

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var closebutton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .senobiBold(size: 30)
        label.textColor = .white
        return label
    }()
    
    public lazy var topView: TopCellContents = {
        let view = TopCellContents()
        view.shadowView.isHidden = true
        view.startButton.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        view.startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    private let chatView = ChatView()
    
    private let titleFrame: CGRect
    private let topSafeAreaHeight: CGFloat
    
    public var audio: AVAudioPlayer?
    public var audioUrls: [URL]
    public var playNum = 0
    
    // MARK: - LifeCycel
    
    init(conversation: Conversation, cellFrame: CGRect, colors: ChatViewColors) {
        titleFrame = cellFrame
        topSafeAreaHeight = Dimension.safeAreatTopHeight
        audioUrls = conversation.audioUrls.map { URL(string: $0)! }
        
        chatView.collectionView.backgroundColor = colors.mainColor
        chatView.chat = Chat(conversation: conversation,
                             color: colors.mainColor)
        
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        view.backgroundColor = colors.topColor
        
        handleChatView(isShow: true)
        
        titleLabel.text = conversation.title
        topView.viewModel = TopViewModel(conversation: conversation,
                                         cellNumber: 0,
                                         colorType: nil)
        
        if prepareAudio(num: playNum) {
            audio?.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        handleChatView(isShow: false)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: titleFrame.origin.x + 20,
                                  y: titleFrame.origin.y,
                                  width: view.frame.width - titleFrame.origin.x - 70,
                                  height: 50)
        
        view.addSubview(topView)
        topView.frame = CGRect(x: titleFrame.origin.x,
                                 y: titleFrame.origin.y,
                                 width: titleFrame.width,
                                 height: titleFrame.height)
        
        view.addSubview(chatView)
        chatView.frame = CGRect(x: 0,
                                y: topView.frame.origin.y + titleFrame.height,
                                width: view.frame.width,
                                height: view.frame.height - topSafeAreaHeight - topView.frame.height)
        
        view.addSubview(closebutton)
        closebutton.frame = CGRect(x: view.frame.width - 70,
                                   y: topSafeAreaHeight - 20,
                                   width: 60,
                                   height: 60)
    }
    
    func handleChatView(isShow: Bool) {
        
        UIView.animate(withDuration: 0.25) {
            if isShow {
                self.titleLabel.frame.origin.y = self.topSafeAreaHeight + 18
                self.topView.frame.origin.y = self.topSafeAreaHeight + 20
                self.chatView.frame.origin.y = self.topView.frame.origin.y + self.titleFrame.height
                self.closebutton.isHidden =  false
            } else {
                self.titleLabel.frame.origin.y = self.titleFrame.origin.y
                self.topView.frame.origin.y = self.titleFrame.origin.y
                self.chatView.frame.origin.y = self.view.frame.height
                self.closebutton.isHidden = true
            }
            
        } completion: { _ in
            if !isShow {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}
