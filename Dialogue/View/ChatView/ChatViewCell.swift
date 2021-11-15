import UIKit
import SDWebImage

class ChatViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModal: ChatViewModal? {
        didSet { configureUI() }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .systemPink
        iv.clipsToBounds = true
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImageView)
        iconImageView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             paddingLeft: 10,
                             paddingBottom: -4)
        iconImageView.setDimensions(height: 32, width: 32)
        
        addSubview(bubbleContainer)
        bubbleContainer.anchor(top: topAnchor,
                               left: iconImageView.rightAnchor,
                               bottom: bottomAnchor,
                               paddingLeft: 12)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width - 10 - 32).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor,
                        left: bubbleContainer.leftAnchor,
                        bottom: bubbleContainer.bottomAnchor,
                        right: bubbleContainer.rightAnchor,
                        paddingTop: 4,
                        paddingLeft: 12,
                        paddingBottom: 4,
                        paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        textView.text = viewModal.dialogue
        iconImageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
    }
}
