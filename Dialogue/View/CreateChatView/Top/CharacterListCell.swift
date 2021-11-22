import UIKit
import SDWebImage

class CharacterListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModal: DialogueViewModel? {
        didSet {
            configureUI()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiMedium(size: 16)
        label.textColor = .white
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, paddingTop: 10)
        imageView.setDimensions(height: 60, width: 60)
        imageView.centerX(inView: self)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: imageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor,
                         paddingTop: 10,
                         paddingBottom: 10,
                         height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        if viewModal.cellNumber == 0 {
            imageView.image = #imageLiteral(resourceName: "user5")
            imageView.clipsToBounds = false
            nameLabel.text = "追加"
        } else {
            imageView.sd_setImage(with: viewModal.imageUrl, completed: nil)
            nameLabel.text = viewModal.character
        }
    }
}
