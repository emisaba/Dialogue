import UIKit

protocol ChatViewDelegate {
    func didTapCreateButton(view: ChatView)
}

class ChatView: UIView {
    
    // MARK: - Properties
    
    public var delegate: ChatViewDelegate?
    
    private let identifier = "identifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ChatViewCell.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = .systemBlue
        cv.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 15, right: 0)
        cv.backgroundColor = .systemPink
        return cv
    }()
    
    var conversation = Conversation(dictionary: ["":""]) {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

// MARK: - UICollectionViewDataSource

extension ChatView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.dialogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ChatViewCell
        cell.viewModal = ChatViewModal(conversation: conversation, cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
//        let estimatedSizeCell = TalkingViewCell(frame: frame)
//        estimatedSizeCell.dialogue = dialogues[indexPath.row]
//        estimatedSizeCell.layoutIfNeeded()
//
//        let targetSize = CGSize(width: frame.width, height: 1000)
//        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
//
//        return .init(width: frame.width, height: estimatedSize.height)
        
        return CGSize(width: frame.width, height: 50)
    }
}
