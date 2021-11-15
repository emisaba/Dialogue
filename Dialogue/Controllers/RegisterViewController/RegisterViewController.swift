import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("prev", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("next", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 3
        page.pageIndicatorTintColor = .systemGray
        page.currentPageIndicatorTintColor = .systemPink
        return page
    }()
    
    private let identifier = "identifier"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(RegisterCell.self, forCellWithReuseIdentifier: identifier)
        cv.isPagingEnabled = true
        cv.backgroundColor = .white
        return cv
    }()
    
    private var selectedImage = UIImage()
    private var nameText: String = ""
    private var audioText: String = ""
    private var audioUrl: URL = URL(fileURLWithPath: "")
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func uploadDialogue() {
        
        let dialogueItem = DialogueItem(image: selectedImage, audio: audioUrl, text: audioText, character: nameText)
        DialogueService.uploadDialogue(dialogue: dialogueItem) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapPrevButton() {
        let itemIndex = max(pageControl.currentPage - 1, 0)
        pageControl.currentPage = itemIndex
        
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: IndexPath(item: itemIndex, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.isPagingEnabled = true
        
        nextButton.setTitle("next", for: .normal)
    }
    
    @objc func didTapNextButton() {
        
        if pageControl.currentPage == 2 {
            uploadDialogue()
        } else {
            let itemIndex = min(pageControl.currentPage + 1, 2)
            pageControl.currentPage = itemIndex
            
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: itemIndex, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
            
            let buttonTitle = pageControl.currentPage == 2 ? "register" : "next"
            nextButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingBottom: 10,
                         height: 50)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: stackView.topAnchor,
                              right: view.rightAnchor)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
    }
}

// MARK: - UICollectionViewDataSource

extension RegisterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! RegisterCell
        cell.viewModal = RegisterViewModal(pageNumber: indexPath.row)
        cell.delegate = self
        cell.recordingView.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - UIScrollViewDelegate

extension RegisterViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offset = targetContentOffset.pointee.x
        pageControl.currentPage = Int(offset / view.frame.width)
        
        let buttonTitle = pageControl.currentPage == 2 ? "register" : "next"
        nextButton.setTitle(buttonTitle, for: .normal)
    }
}

// MARK: - RegisterCellDelegate

extension RegisterViewController: RegisterCellDelegate {
    
    func didChangeText(text: String) {
        nameText = text
    }
    
    func didTapCharactorButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - RecordingViewDelegate

extension RegisterViewController: RecordingViewDelegate {
    
    func audioInfo(audioInfo: AudioInfo) {
        audioText = audioInfo.text
        audioUrl = audioInfo.audio
    }
}

// MARK: - UIImagePickerController

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? RegisterCell else { return }
        cell.charactorImage.setImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
