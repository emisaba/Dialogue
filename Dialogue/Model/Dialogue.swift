import UIKit

struct Dialogue {
    
    let character: String
    let dialogue: String
    let imageUrl: String
    let audioUrl: String
    
    init(dictionary: [String: Any]) {
        self.character = dictionary["character"] as? String ?? ""
        self.dialogue = dictionary["dialogue"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.audioUrl = dictionary["audioUrl"] as? String ?? ""
    }
}
