import UIKit

extension UILabel {
    
    static func createLabel(size: CGFloat, color: CellColorType? = nil, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .senobiBold(size: size)
        label.textColor = color == nil ? .white : color?.chatViewMainColor
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
