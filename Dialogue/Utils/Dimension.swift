import UIKit

struct Dimension {
    
    static var safeAreatTopHeight: CGFloat = 0
    
    static var safeareaTop: CGFloat {
        
        get {
            return safeAreatTopHeight
        }
        set(height) {
            safeAreatTopHeight = height
        }
    }
}
