import UIKit
import AVFoundation

class CreateChatController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    private let headerIdentifier = "headerIdentifier"
    public let backButton = UIButton.createTextButton(target: self, action: #selector(didTapBackButton), title: "↓")
    private let registerButton = UIButton.createTextButton(target: self, action: #selector(didTapRegisterButton), title: "登録")
    
    public lazy var characterListView: CharacterListView = {
        let view = CharacterListView()
        view.delegate = self
        return view
    }()
    
    public lazy var dialogueListView: UITableView = {
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
    
    private let titleTextField: CustomTextField = {
        let tf = CustomTextField()
        tf.backgroundColor = CellColorType.blue.chatViewMainColor
        tf.layer.cornerRadius = 30
        tf.textColor = .white
        tf.layer.borderWidth = 0
        tf.placeholder = "タイトルを入力してください"
        tf.font = .senobi(size: 18)
        tf.isHidden = true
        return tf
    }()
    
    private let dialogueListDescription = UILabel.createLabel(size: 18, color: .orange, text: "1. キャラを選択すると\nセリフが表示されます")
    private let bottomChatDescription = UILabel.createLabel(size: 18, color: .pink, text: "2. セリフを選択すると\n会話が表示されます")
    private let registerDescription = UILabel.createLabel(size: 18, color: .blue, text: "3. 会話が完成したらタイトルを入力し\n登録してください")
    
    private let addDialogueButton = UIButton.createImageButton(target: self,
                                                               action: #selector(didTapAddDialogueButton),
                                                               image: #imageLiteral(resourceName: "add-comment"),
                                                               isFrame: false,
                                                               inset: UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 10))
    
    private let startButton = UIButton.createImageButton(target: self,
                                                         action: #selector(didTapStartButton),
                                                         image: #imageLiteral(resourceName: "start"),
                                                         isFrame: true,
                                                         inset: UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
    
    public var dialoguesBySelectedCharacter: [Dialogue] = [] {
        didSet {
            dialogueListDescription.isHidden = true
            addDialogueButton.isHidden = false
        }
    }
    
    public lazy var conversationBottomView: BottomChatView = {
        let view = BottomChatView()
        view.delegate = self
        return view
    }()
    
    
    public var selectedCharacter: Dialogue?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddDialogueButton() {
        guard let imageUrl = URL(string: selectedCharacter?.imageUrl ?? "") else { return }
        guard let name = selectedCharacter?.character else { return }
        let characterInfo = CharacterInfo(imageUrl: imageUrl, name: name)
        
        let vc = RegisterDialogueController(characterInfo: characterInfo)
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
        
        guard let title = titleTextField.text else { return }
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
                          right: view.rightAnchor)
        backButton.setDimensions(height: 60, width: 100)
        
        registerButton.isHidden = true
        view.addSubview(registerButton)
        registerButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.safeAreaLayoutGuide.rightAnchor,
                              paddingBottom: 15,
                              paddingRight: 20)
        registerButton.setDimensions(height: 60, width: 60)
        
        view.addSubview(titleTextField)
        titleTextField.anchor(left: view.leftAnchor,
                              right: registerButton.leftAnchor,
                              paddingLeft: 20,
                              paddingRight: 20)
        titleTextField.setDimensions(height: 60, width: 250)
        titleTextField.centerY(inView: registerButton)
        
        view.addSubview(registerDescription)
        registerDescription.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   paddingBottom: 18)
        registerDescription.centerX(inView: view)
        
        view.addSubview(conversationBottomView)
        conversationBottomView.anchor(left: view.leftAnchor,
                                      bottom: registerButton.topAnchor,
                                      right: view.rightAnchor,
                                      paddingBottom: 75,
                                      height: 130)
        conversationBottomView.backgroundColor = .clear
        
        conversationBottomView.addSubview(bottomChatDescription)
        bottomChatDescription.anchor(top: conversationBottomView.topAnchor,
                                     paddingTop: 50)
        bottomChatDescription.centerX(inView: view)
        
        view.addSubview(dialogueListView)
        dialogueListView.anchor(top: characterListView.bottomAnchor,
                                left: view.leftAnchor,
                                bottom: conversationBottomView.topAnchor,
                                right: view.rightAnchor,
                                paddingBottom: 50)
        
        dialogueListView.addSubview(dialogueListDescription)
        dialogueListDescription.centerX(inView: dialogueListView)
        dialogueListDescription.anchor(top: dialogueListView.topAnchor,
                                       paddingTop: 110)
        
        createTriangle()
        
        addDialogueButton.isHidden = true
        view.addSubview(addDialogueButton)
        addDialogueButton.anchor(top: dialogueListView.topAnchor,
                                 right: dialogueListView.rightAnchor,
                                 paddingTop: 15,
                                 paddingRight: 10)
        addDialogueButton.setDimensions(height: 60, width: 60)
        
        startButton.isHidden = true
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
        return dialoguesBySelectedCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CreateChatCell
        cell.backgroundColor = .clear
        cell.label.text = dialoguesBySelectedCharacter[indexPath.row].dialogue
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conversationBottomView.convarsations.append(dialoguesBySelectedCharacter[indexPath.row])
        
        bottomChatDescription.isHidden = true
        startButton.isHidden = false
    }
}

// MARK: - BottomChatViewDelegate

extension CreateChatController: BottomChatViewDelegate {
    func moreThanTwoConversations() {
        registerDescription.isHidden = true
        registerButton.isHidden = false
        titleTextField.isHidden = false
    }
}
