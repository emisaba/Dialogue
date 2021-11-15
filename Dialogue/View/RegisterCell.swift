import UIKit

protocol RegisterCellDelegate {
    func didTapCharactorButton()
    func didChangeText(text: String)
}

class RegisterCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: RegisterCellDelegate?
    
    public var viewModal: RegisterViewModal? {
        didSet { configureUI() }
    }
    
    private lazy var nameTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        return tf
    }()
    
    lazy var charactorImage: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemGray
        button.addTarget(self, action: #selector(didTapCharactorButton), for: .touchUpInside)
        return button
    }()
    
    var recordingView = RecordingView()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
        nameTextField.setDimensions(height: 50, width: frame.width - 50)
        nameTextField.centerX(inView: self)
        nameTextField.centerY(inView: self)
        
        addSubview(charactorImage)
        charactorImage.setDimensions(height: 120, width: 120)
        charactorImage.centerX(inView: self)
        charactorImage.centerY(inView: self)
        
        addSubview(recordingView)
        recordingView.setDimensions(height: 400, width: frame.width - 40)
        recordingView.centerY(inView: self)
        recordingView.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    // MARK: - Actions
    
    @objc func didTapCharactorButton() {
        delegate?.didTapCharactorButton()
    }
    
    @objc func didChangeText() {
        guard let text = nameTextField.text else { return }
        delegate?.didChangeText(text: text)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        nameTextField.isHidden = viewModal.shouldHideName
        charactorImage.isHidden = viewModal.shouldHideImage
        recordingView.isHidden = viewModal.shouldHideAudio
    }
}
