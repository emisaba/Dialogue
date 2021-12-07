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
        iv.image = #imageLiteral(resourceName: "character")
        return iv
    }()
    
    private let dialogueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = CellColorType.pink.chatViewMainColor
        label.font = .senobi(size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private let bubbleTail = BubbleTail(frame: .zero, color: CellColorType.pink.chatViewMainColor)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dialogueLabel)
        dialogueLabel.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 45,
                             paddingLeft: 84,
                             paddingRight: 20,
                             height: 62)
        
        addSubview(imageView)
        imageView.anchor(left: leftAnchor,
                         paddingLeft: 10)
        imageView.setDimensions(height: 60, width: 60)
        imageView.centerY(inView: dialogueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(bubbleTail)
        bubbleTail.frame = CGRect(x: 60, y: 78, width: 25, height: 20)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
        dialogueLabel.text = viewModal.dialogue.dialogue
    }
}
