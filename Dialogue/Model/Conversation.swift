import UIKit

class Conversation {
    let audioUrls: [String]
    let caracterImageUrls: [String]
    let dialogs: [String]
    let title: String
    
    
    init(dictionary: [String: Any]) {
        self.audioUrls = dictionary["audioUrls"] as? [String] ?? [""]
        self.caracterImageUrls = dictionary["caracterImageUrls"] as? [String] ?? [""]
        self.dialogs = dictionary["dialogs"] as? [String] ?? [""]
        self.title = dictionary["title"] as? String ?? ""
    }
}
