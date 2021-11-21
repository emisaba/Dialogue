import UIKit

protocol CharacterListViewDelegate {
    func showRegisterViewController()
    func fetchCharacter()
    func selectCharacter(dialogues: [Dialogue])
}

class CharacterListView: UIView {
    
    // MARK: - Properties
    
    public var delegate: CharacterListViewDelegate? {
        didSet { delegate?.fetchCharacter() }
    }
    
    private let identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(CharacterListCell.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = .white
        cv.backgroundColor = .systemGray
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return cv
    }()
    
    private let firstDialogue = Dialogue(dictionary: ["":""])
    public lazy var dialogues: [Dialogue] = [firstDialogue] {
        didSet { collectionView.reloadData() }
    }
    
    private var selectedDialogues: [Dialogue] = []
    
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
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

// MARK: - UICollectionViewDataSource

extension CharacterListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialogues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CharacterListCell
        cell.viewModal = DialogueViewModel(dialogue: dialogues[indexPath.row], cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CharacterListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            delegate?.showRegisterViewController()
            
        } else {
            selectedDialogues = []
            guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterListCell else { return }
            
            dialogues.forEach { dialogue in
                if dialogue.character == cell.viewModal?.character {
                    selectedDialogues.append(dialogue)
                }
            }
            delegate?.selectCharacter(dialogues: selectedDialogues)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharacterListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = frame.height
        return CGSize(width: height - 10, height: height)
    }
}

