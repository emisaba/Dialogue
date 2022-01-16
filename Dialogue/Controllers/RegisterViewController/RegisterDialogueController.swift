import UIKit

class RegisterDialogueController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "left-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    private let instructionLabel = UILabel.createLabel(size: 18)
    
    private var recordingView: RecordingView?
    
    // MARK: - LifeCycle
    
    init(characterInfo: CharacterInfo) {
        recordingView = RecordingView(frame: .zero, color: .purple, characterInfo: characterInfo)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = CellColorType.purple.cellColor
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
        
        guard let recordingView = recordingView else { return }
        view.addSubview(recordingView)
        recordingView.setDimensions(height: 260, width: view.frame.width - 40)
        recordingView.centerX(inView: view)
        recordingView.centerY(inView: view)
        
        view.addSubview(instructionLabel)
        instructionLabel.text = "音声を録音してください"
        instructionLabel.anchor(bottom: recordingView.topAnchor, paddingBottom: 50)
        instructionLabel.centerX(inView: view)
    }
}
