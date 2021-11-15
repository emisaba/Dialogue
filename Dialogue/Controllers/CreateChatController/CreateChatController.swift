import UIKit
import AVFoundation

class CreateChatController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    private let headerIdentifier = "headerIdentifier"
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    public lazy var characterListView: CharacterListView = {
        let view = CharacterListView()
        view.delegate = self
        return view
    }()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CreateChatCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    public var dialoguesBySelectedCharacter: [Dialogue] = []
    
    private lazy var addDialogueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapAddDialogueButton), for: .touchUpInside)
        return button
    }()
    
    public let conversationBottomView = BottomChatView()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    public let alertBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    public var customAlertConstraint: NSLayoutConstraint?
    public lazy var customAlert: CustomAlert = {
        let alert = CustomAlert()
        alert.alpha = 0
        alert.layer.cornerRadius = 5
        alert.delegate = self
        return alert
    }()
    
    public var audioPlayer: AVAudioPlayer?
    public var selectedAudios: [URL] = []
    public var selectedAudiosUrlString: [String] = []
    public var playNum = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func fetchDialogue() {
        DialogueService.fetchDialogue { dialogues in
            dialogues.forEach { self.characterListView.dialogues.append($0) }
        }
    }
    
    func uploadConversation(title: String, members: [String], dialogues: [String]) {
        
        let conversationInfo = ConversationInfo(conversations: selectedAudiosUrlString,
                                                members: members,
                                                dialogues: dialogues,
                                                title: title)

        ChatService.uploadConversation(info: conversationInfo) { error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            self.dismissAlerView()
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapAddDialogueButton() {
        let vc = RegisterDialogueController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapStartButton() {
        selectedAudios = []
        selectedAudiosUrlString = []
        
        conversationBottomView.convarsations.forEach { dialogue in
            selectedAudiosUrlString.append(dialogue.audioUrl)
            
            guard let url = URL(string: dialogue.audioUrl) else { return }
            selectedAudios.append(url)
        }
        startPlay()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 10)
        backButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              right: view.rightAnchor,
                              paddingRight: 10)
        registerButton.setDimensions(height: 60, width: 150)
        
        view.addSubview(characterListView)
        characterListView.anchor(top: backButton.bottomAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 10,
                                 height: 100)
        
        view.addSubview(conversationBottomView)
        conversationBottomView.anchor(left: view.leftAnchor,
                                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                      right: view.rightAnchor,
                                      height: 120)
        
        view.addSubview(tableView)
        tableView.anchor(top: characterListView.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: conversationBottomView.topAnchor,
                         right: view.rightAnchor)
        
        view.addSubview(addDialogueButton)
        addDialogueButton.anchor(top: tableView.topAnchor,
                                 right: tableView.rightAnchor,
                                 paddingTop: 10,
                                 paddingRight: 10)
        addDialogueButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(startButton)
        startButton.anchor(bottom: conversationBottomView.topAnchor,
                           right: view.rightAnchor,
                           paddingBottom: -30,
                           paddingRight: 10)
        startButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(alertBackgroundView)
        alertBackgroundView.fillSuperview()
        
        view.addSubview(customAlert)
        customAlert.anchor(left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingLeft: 20,
                           paddingRight: 20,
                           height: 150)
        customAlertConstraint = customAlert.topAnchor.constraint(equalTo: view.topAnchor,
                                                                 constant: view.frame.height / 2 - 75)
    }
}

// MARK: - UITableViewDataSource

extension CreateChatController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialoguesBySelectedCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CreateChatCell
        cell.label.text = dialoguesBySelectedCharacter[indexPath.row].dialogue
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conversationBottomView.convarsations.append(dialoguesBySelectedCharacter[indexPath.row])
    }
}
