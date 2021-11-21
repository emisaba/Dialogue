import UIKit
import SDWebImage

class BottomChatCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModal: DialogueViewModel? {
        didSet { configureUI() }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 30
        iv.backgroundColor = .systemGreen
        iv.clipsToBounds = true
        return iv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isUserInteractionEnabled = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .systemYellow
        return tv
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(left: leftAnchor,
                         paddingLeft: 10)
        imageView.setDimensions(height: 60, width: 60)
        imageView.centerY(inView: self)
        
        addSubview(bubbleContainer)
        bubbleContainer.anchor(left: imageView.rightAnchor,
                               right: rightAnchor,
                               paddingLeft: 10,
                               paddingRight: 10,
                               height: 100)
        bubbleContainer.centerY(inView: self)
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        left: bubbleContainer.leftAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingTop: 4, paddingLeft: 12,
                        paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
        textView.text = viewModal.dialogue.dialogue
    }
}
