import UIKit
import SDWebImage

class ChatViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: ChatViewModel? {
        didSet { configureUI() }
    }
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        tv.backgroundColor = .clear
        tv.font = .senobi(size: 20)
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let bubbleTail = BubbleTail(frame: .zero, color: .white)
    
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
                               paddingLeft: 14)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(bubbleTail)
        bubbleTail.frame = CGRect(x: 45, y: frame.height - 22, width: 18, height: 10)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModel = viewModel else { return }
        
        textView.text = viewModel.dialogue
        textView.textColor = viewModel.textColor
        iconImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
