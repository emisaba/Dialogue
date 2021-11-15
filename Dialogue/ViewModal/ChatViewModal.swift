import UIKit

struct ChatViewModal {
    let conversation: Conversation
    let cellNumber: Int
    
    var imageUrl: URL? {
        return URL(string: conversation.caracterImageUrls[cellNumber])
    }
    
    var dialogue: String {
        return conversation.dialogs[cellNumber]
    }
    
    init(conversation: Conversation, cellNumber: Int) {
        self.conversation = conversation
        self.cellNumber = cellNumber
    }
}
