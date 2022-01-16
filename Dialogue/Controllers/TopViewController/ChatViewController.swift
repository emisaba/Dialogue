import UIKit
import AVFoundation

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var closebutton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
    public let selectedCell: TopCellContents?
    
    public var audio: AVAudioPlayer?
    public var audioUrls: [URL]
    public var playNum = 0
    
    // MARK: - LifeCycel
    
    init(conversation: Conversation, colors: ChatViewColors, selectedCell: TopCellContents) {
        self.selectedCell = selectedCell
        audioUrls = conversation.audioUrls.map { URL(string: $0)! }
        
        chatView.collectionView.backgroundColor = colors.mainColor
        chatView.chat = Chat(conversation: conversation,
                             color: colors.mainColor)
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = colors.topColor
        
        titleLabel.text = conversation.title
        topView.viewModel = TopViewModel(conversation: conversation,
                                         cellNumber: 0,
                                         colorType: nil)
        
        if prepareAudio(num: playNum) { audio?.play() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        dismiss(animated: true) {
            self.selectedCell?.baseView.hero.id = ""
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor,
                       height: 170)
        
        topView.addSubview(titleLabel)
        titleLabel.anchor(top: topView.topAnchor,
                          left: topView.leftAnchor,
                          right: topView.rightAnchor,
                          paddingLeft: 20,
                          height: 50)
        
        view.addSubview(chatView)
        chatView.anchor(top: topView.bottomAnchor,
                        left: view.leftAnchor,
                        bottom: view.bottomAnchor,
                        right: view.rightAnchor)
        
        view.addSubview(closebutton)
        closebutton.anchor(top: view.topAnchor,
                           right: topView.rightAnchor,
                           paddingTop: 20,
                           paddingRight: 20)
        closebutton.setDimensions(height: 60, width: 60)
    }
}
