import UIKit

struct TopViewModal {
    let conversation: Conversation
    let cellNumber: Int
    
    var titile: String {
        return conversation.title
    }
    
    init(conversation: Conversation, cellNumber: Int) {
        self.conversation = conversation
        self.cellNumber = cellNumber
    }
}
