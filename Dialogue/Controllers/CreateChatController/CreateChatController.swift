import UIKit
import AVFoundation

class CreateChatController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    private let headerIdentifier = "headerIdentifier"
    
    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
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
        tableView.backgroundColor = CellColorType.yellow.cellColor
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
        tf.font = .senobi(size: 18)
        tf.isHidden = true
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: CellColorType.blue.cellColor]
        tf.attributedPlaceholder = NSAttributedString(string: "タイトルを入力してください", attributes: attributes)
        
        return tf
    }()
    
    public let addDialogueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "add-comment"), for: .normal)
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(didTapAddDialogueButton), for: .touchUpInside)
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "start"), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25
        button.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    public let dialogueListDescription = UILabel.createLabel(size: 20, color: .yellow, text: "セリフが表示されます")
    private let bottomChatDescription = UILabel.createLabel(size: 20, color: .green, text: "会話が表示されます")
    private let registerDescription = UILabel.createLabel(size: 20, color: .blue, text: "タイトル入力欄が表示されます")
    
    public lazy var conversationBottomView: BottomChatView = {
        let view = BottomChatView()
        view.delegate = self
        return view
    }()
    
    public var selectedCharacter: Character?
    
    public var audioPlayer: AVAudioPlayer?
    public var selectedAudios: [URL] = []
    public var playNum = 0
    
    public var characters: [Character] = []
    public var dialogues: [Dialogue] = []
    public var selectedDialogues: [Dialogue] = []
    
    private var keyboardFrameHeight: CGFloat = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCharacters()
        fetchDialogues()
        configureUI()
        detectKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    
    func fetchCharacters() {
        CharacterService.fetchCharacter { characters in
            self.characters = characters
            characters.forEach { self.characterListView.characters.append($0) }
            self.characterListView.collectionView.reloadData()
        }
    }
    
    func fetchDialogues() {
        DialogueService.fetchDialogue { dialogues in
            self.dialogues = dialogues
        }
    }
    
    func uploadConversation(title: String, members: [String], dialogues: [String]) {
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame.origin.y += self.keyboardFrameHeight
            self.view.endEditing(true)
            
        } completion: { _ in
            
            let conversationInfo = ConversationInfo(conversations: self.selectedAudiosUrlStrings(),
                                                    members: members,
                                                    dialogues: dialogues,
                                                    title: title)

            ChatService.uploadConversation(info: conversationInfo) { error in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAddDialogueButton() {
        guard let selectedCharacter = selectedCharacter else { return }
        guard let imageUrl = URL(string: selectedCharacter.imageUrl) else { return }
        let id = selectedCharacter.characterID
        let name = selectedCharacter.character
        let characterInfo = CharacterInfo(id: id, imageUrl: imageUrl, name: name)
        
        let vc = RegisterDialogueController(characterInfo: characterInfo)
        vc.completion = { dialogues in
            self.dialogues = dialogues
            self.updateDialogues(character: selectedCharacter)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            self.keyboardFrameHeight = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 0.25) {
                self.view.frame.origin.y -= keyboardFrame.cgRectValue.height
            }
        }
    }
    
    @objc func didTapRegisterButton() {
        
        guard let title = titleTextField.text else { return }
        let members = conversationBottomView.dialogues.map { $0.imageUrl }
        let dialogues = conversationBottomView.dialogues.map { $0.dialogue }
        
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
                          right: view.rightAnchor, paddingRight: 10)
        backButton.setDimensions(height: 60, width: 60)
        
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
                                     paddingTop: 60)
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
    
    func selectedAudiosUrlStrings() -> [String] {
        let selectedAudiosUrlStrings = conversationBottomView.dialogues.map { $0.audioUrl }
        return selectedAudiosUrlStrings
    }
    
    func updateCharacter(newInfo: NewInfo) {
        self.characterListView.characters = []
        self.characterListView.characters.append(self.characterListView.addButton)
        newInfo.characters.forEach { self.characterListView.characters.append($0) }
        self.characterListView.collectionView.reloadData()
        
        self.characters = newInfo.characters
        self.dialogues = newInfo.dialogues
    }
    
    func updateDialogues(character: Character) {
        selectedDialogues = []
        
        dialogues.forEach {
            if $0.characterID == character.characterID {
                selectedDialogues.append($0)
            }
        }
        
        dialogueListView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CreateChatController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDialogues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CreateChatCell
        cell.backgroundColor = .clear
        cell.label.text = selectedDialogues[indexPath.row].dialogue
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        conversationBottomView.dialogues.append(selectedDialogues[indexPath.row])
        
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
