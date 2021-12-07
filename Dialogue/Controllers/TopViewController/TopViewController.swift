import UIKit
import Hero

class TopViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.register(TopCell.self, forCellReuseIdentifier: identifier)
        tv.rowHeight = 170
        tv.allowsSelection = false
        tv.separatorStyle = .none
        return tv
    }()
    
    private let buttonBackgroundView = UIView()
    
    private lazy var moveToCreateChatViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CellColorType.blue.cellColor
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private var conversations: [Conversation] = []
    private var cellNumber = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchConversations()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Dimension.safeAreatTopHeight = view.safeAreaInsets.top
        Dimension.safeAreatBottomHeight = view.safeAreaInsets.bottom
    }
    
    // MARK: - API
    
    func fetchConversations() {
        ChatService.fetchConversation { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCreateButton() {
        buttonBackgroundView.hero.id = "moveToCreateChatView"
        moveToCreateChatViewButton.hero.id = "moveToCreateChatViewButton"
        
        let vc = CreateChatController()
        vc.view.hero.id = "moveToCreateChatView"
        vc.backButton.hero.id = "moveToCreateChatViewButton"
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.isHeroEnabled = true
        
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(buttonBackgroundView)
        buttonBackgroundView.anchor(bottom: view.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingBottom: -60,
                                    paddingRight: -60)
        buttonBackgroundView.setDimensions(height: 180, width: 180)
        buttonBackgroundView.layer.cornerRadius = 90
        buttonBackgroundView.backgroundColor = CellColorType.yellow.cellColor
        
        buttonBackgroundView.addSubview(moveToCreateChatViewButton)
        moveToCreateChatViewButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                          right: view.rightAnchor,
                                          paddingRight: 20)
        moveToCreateChatViewButton.setDimensions(height: 60, width: 60)
    }
}

// MARK: - UITableViewDataSource

extension TopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TopCell
        cell.topCellView.delegate = self
        
        if cellNumber > 5 { cellNumber = 0 }
        cell.topCellView.viewModel = TopViewModel(conversation: conversations[indexPath.row],
                                                  cellNumber: indexPath.row,
                                                  colorType: CellColorType.allCases[cellNumber])
        cellNumber += 1
        return cell
    }
}

// MARK: - TopCellViewDelegate

extension TopViewController: TopCellViewDelegate {
    
    func didTapStartButton(cell: TopCellContents) {
        
        guard let viewModel = cell.viewModel else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: viewModel.cellNumber, section: 0)) as? TopCell else { return }
        cell.topCellView.baseView.hero.id = "openChatView"
        
        let vc = ChatViewController(conversation: conversations[viewModel.cellNumber],
                                    colors: ChatViewColors(topColor: viewModel.cellColor,
                                                           mainColor: viewModel.chatViewColor),
                                    selectedCell: cell.topCellView)
        vc.topView.hero.id = "openChatView"
        vc.isHeroEnabled = true
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}
