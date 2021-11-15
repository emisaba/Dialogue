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
    
    private var recordingView = RecordingView()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(recordingView)
        recordingView.setDimensions(height: 400, width: view.frame.width - 40)
        recordingView.centerX(inView: view)
        recordingView.centerY(inView: view)
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
