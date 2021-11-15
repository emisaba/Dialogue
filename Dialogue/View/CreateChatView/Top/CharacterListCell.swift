import UIKit
import SDWebImage

class CharacterListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModal: DialogueViewModal? {
        didSet { configureUI() }
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = (frame.width - 20) / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingLeft: 10,
                         paddingRight: 10,
                         height: frame.width - 30)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: imageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 10,
                         height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
        nameLabel.text = viewModal.character
    }
}
