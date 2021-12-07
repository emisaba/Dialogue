import UIKit

extension UILabel {
    
    static func createLabel(size: CGFloat, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiBold(size: size)
        label.textColor = .white
        label.text = text
        return label
    }
}
