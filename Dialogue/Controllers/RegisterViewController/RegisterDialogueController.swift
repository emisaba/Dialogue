import UIKit

class RegisterDialogueController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private var recordingView: RecordingView?
    
    // MARK: - LifeCycle
    
    init(characterInfo: CharacterInfo) {
        recordingView = RecordingView(frame: .zero, color: .orange, characterInfo: characterInfo)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CellColorType.orange.cellColor
        
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
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
