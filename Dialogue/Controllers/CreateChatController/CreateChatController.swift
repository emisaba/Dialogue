import UIKit
import AVFoundation

class CreateChatController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    private let headerIdentifier = "headerIdentifier"
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("< トップ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .senobiBold(size: 18)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("登録", for: .normal)
        button.setTitleColor(CellColorType.blue.cellColor, for: .normal)
        button.titleLabel?.font = .senobiMedium(size: 18)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
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
        tableView.backgroundColor = CellColorType.orange.cellColor
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 50, right: 0)
        return tableView
    }()
    
    public var dialoguesBySelectedCharacter: [Dialogue] = []
    
    private lazy var addDialogueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 10)
        button.layer.cornerRadius = 30
        button.setImage(#imageLiteral(resourceName: "add-comment"), for: .normal)
        button.addTarget(self, action: #selector(didTapAddDialogueButton), for: .touchUpInside)
        return button
    }()
    
    public let conversationBottomView = BottomChatView()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    private let customTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.backgroundColor = CellColorType.blue.chatViewMainColor
        tf.layer.cornerRadius = 30
        tf.textColor = .white
        tf.layer.borderWidth = 0
        tf.placeholder = "タイトルを入力してください"
        tf.font = .senobi(size: 18)
        return tf
    }()
    
    public var audioPlayer: AVAudioPlayer?
    public var selectedAudios: [URL] = []
    public var selectedAudiosUrlString: [String] = []
    public var playNum = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        detectKeyboard()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
            self.navigationController?.popViewController(animated: true)
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
    
    @objc func showKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y -= keyboardFrame.cgRectValue.height
            }
        }
    }
    
    @objc func didTapRegisterButton() {
        
        guard let title = customTextField.text else { return }
        let members = conversationBottomView.convarsations.map { $0.imageUrl }
        let dialogues = conversationBottomView.convarsations.map { $0.dialogue }
        
        uploadConversation(title: title, members: members, dialogues: dialogues)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = CellColorType.blue.cellColor
        
        view.addSubview(characterListView)
        characterListView.anchor(top: view.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 height: Dimension.safeAreatTopHeight + 110)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,
                          left: view.leftAnchor,
                          paddingLeft: 0)
        backButton.setDimensions(height: 60, width: 100)
        
        view.addSubview(registerButton)
        registerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.safeAreaLayoutGuide.rightAnchor,
                              paddingRight: 20)
        registerButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(customTextField)
        customTextField.anchor(left: view.leftAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: registerButton.leftAnchor,
                               paddingLeft: 20, paddingRight: 20)
        customTextField.setDimensions(height: 60, width: 250)
        
        view.addSubview(conversationBottomView)
        conversationBottomView.anchor(left: view.leftAnchor,
                                      bottom: registerButton.topAnchor,
                                      right: view.rightAnchor,
                                      paddingBottom: 70,
                                      height: 120)
        conversationBottomView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.anchor(top: characterListView.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: conversationBottomView.topAnchor,
                         right: view.rightAnchor,
                         paddingBottom: 50)
        
        view.addSubview(addDialogueButton)
        addDialogueButton.anchor(top: tableView.topAnchor,
                                 right: tableView.rightAnchor,
                                 paddingTop: 15,
                                 paddingRight: 10)
        addDialogueButton.setDimensions(height: 60, width: 60)
        
        createTriangle()
        
        view.addSubview(startButton)
        startButton.anchor(bottom: conversationBottomView.topAnchor,
                           right: view.rightAnchor,
                           paddingBottom: -30,
                           paddingRight: 20)
        startButton.setDimensions(height: 50, width: 50)
    }
    
    func detectKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
}

// MARK: - UITableViewDataSource

extension CreateChatController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialoguesBySelectedCharacter.count == 0 ? 15 : dialoguesBySelectedCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CreateChatCell
        cell.backgroundColor = .clear
        
        if dialoguesBySelectedCharacter.count > 0 {
            cell.label.text = dialoguesBySelectedCharacter[indexPath.row].dialogue
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conversationBottomView.convarsations.append(dialoguesBySelectedCharacter[indexPath.row])
    }
}
