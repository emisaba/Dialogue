import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: frame.height))
        leftView = leftPaddingView
        leftViewMode = .always
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 5
        placeholder = "input name..."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
