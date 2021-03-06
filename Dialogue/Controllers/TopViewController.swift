import UIKit

class TopViewController: UIViewController {
    
    // MARK: - Properties
    
    private let identifier = "identifier"
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.register(TopCell.self, forCellReuseIdentifier: identifier)
        tv.rowHeight = 150
        tv.allowsSelection = false
        tv.separatorStyle = .none
        return tv
    }()
    
    private lazy var moveToDialoguePageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private var conversations: [Conversation] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
        let vc = CreateChatController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(moveToDialoguePageButton)
        moveToDialoguePageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingBottom: 10,
                            paddingRight: 20)
        moveToDialoguePageButton.setDimensions(height: 60, width: 60)
    }
}

// MARK: - UITableViewDataSource

extension TopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TopCell
        cell.topCellView.viewModal = TopViewModal(conversation: conversations[indexPath.row],
                                                  cellNumber: indexPath.row)
        cell.topCellView.delegate = self
        return cell
    }
}

// MARK: - TopCellViewDelegate

extension TopViewController: TopCellViewDelegate {
    
    func didTapStartButton(cell: TopCellContents) {
        
        guard let cellNumber = cell.viewModal?.cellNumber else { return }
        guard let cell = tableView.cellForRow(at: IndexPath(row: cellNumber, section: 0)) else { return }
        let topSafeArea = view.safeAreaInsets.top
        
        let cellFrame = cell.frame
        let modifyCellFrame = CGRect(x: cellFrame.origin.x,
                                     y: cellFrame.origin.y + topSafeArea,
                                     width: cellFrame.size.width,
                                     height: cellFrame.size.height)
        
        let vc = ChatViewController(conversation: conversations[cellNumber],
                                           cellFrame: modifyCellFrame,
                                           topSafeArea: topSafeArea)
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
