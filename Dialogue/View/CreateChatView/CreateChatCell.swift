import UIKit

class CreateChatCell: UITableViewCell {
    
    // MARK: - Properties
    
    public var label: UILabel = {
        let label = UILabel()
        label.font = .senobi(size: 22)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
