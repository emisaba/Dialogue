import UIKit

protocol CharacterListViewDelegate {
    func showRegisterViewController()
    func selectCharacter(character: Character)
}

class CharacterListView: UIView {
    
    // MARK: - Properties
    
    public var delegate: CharacterListViewDelegate?
    private let identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = CellColorType.pink.cellColor
        cv.register(CharacterListCell.self, forCellWithReuseIdentifier: identifier)
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    public let addButton = Character(dictionary: ["":""])
    public lazy var characters: [Character] = [addButton] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = CellColorType.pink.cellColor
        
        addSubview(collectionView)
        collectionView.anchor(top: safeAreaLayoutGuide.topAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              height: 110)
    }
}

// MARK: - UICollectionViewDataSource

extension CharacterListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CharacterListCell
        cell.viewModal = CharacterViewModel(character: characters[indexPath.row], cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CharacterListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            delegate?.showRegisterViewController()
            
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterListCell else { return }
            guard let character = cell.viewModal?.character else { return }
            delegate?.selectCharacter(character: character)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharacterListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = frame.height - Dimension.safeAreatTopHeight
        return CGSize(width: height - 30, height: height)
    }
}

