import UIKit

struct TopViewModel {
    let conversation: Conversation
    let cellNumber: Int
    let colorType: CellColorType?
    
    var titile: String {
        return conversation.title
    }
    
    var cellColor: UIColor {
        return colorType?.cellColor ?? .clear
    }
    
    var chatViewColor: UIColor {
        return colorType?.chatViewMainColor ?? .clear
    }
    
    var titileTextColor: UIColor {
        return colorType == nil ? .clear : .white
    }
    
    init(conversation: Conversation, cellNumber: Int, colorType: CellColorType?) {
        self.conversation = conversation
        self.cellNumber = cellNumber
        self.colorType = colorType
    }
}
