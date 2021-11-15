import UIKit

protocol TopCellViewDelegate {
    func didTapStartButton(cell: TopCellContents)
}

class TopCellContents: UIView {
    
    // MARK: - Properties
    
    public var viewModal: TopViewModal? {
        didSet {
            guard let viewModal = viewModal else { return }
            membersView = MembersView(frame: .zero, conversation: viewModal.conversation)
            configureUI()
        }
    }
    
    public var delegate: TopCellViewDelegate?
    
    private let baseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.systemPink.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    lazy var membersView = MembersView(frame: .zero, conversation: Conversation(dictionary: [:]))
    var didShowChatView = false
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapStartButton() {
        didShowChatView = true
        delegate?.didTapStartButton(cell: self)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let viewModal = viewModal else { return }
        
        addSubview(baseView)
        baseView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 10,
                        paddingRight: 40)
        
        addSubview(startButton)
        startButton.anchor(right: rightAnchor,
                           paddingRight: 10)
        startButton.setDimensions(height: 60, width: 60)
        startButton.centerY(inView: self)
        
        titleLabel.text = viewModal.titile
        let stackView = UIStackView(arrangedSubviews: [titleLabel, membersView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: baseView.topAnchor,
                         left: baseView.leftAnchor,
                         bottom: baseView.bottomAnchor,
                         right: startButton.leftAnchor,
                         paddingTop: 10,
                         paddingLeft: 10,
                         paddingBottom: 10,
                         paddingRight: 10)
    }
}
