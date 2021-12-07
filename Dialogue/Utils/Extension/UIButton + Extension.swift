import UIKit

extension UIButton {
    
    static func createButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = CellColorType.pink.chatViewMainColor
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func createStartButton(target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = CellColorType.pink.chatViewMainColor
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
