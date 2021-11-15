import UIKit

struct DialogueService {
    
    static func uploadDialogue(dialogue: DialogueItem, completion: @escaping((Error?) -> Void)) {
        
        DataUploader.uploadDialogue(dialogueItem: dialogue) { downloadURLs in
            let character = dialogue.character
            let dialogue = dialogue.text
            let imageUrl = downloadURLs.image
            let audioUrl = downloadURLs.audio
            
            let data: [String: Any] = ["character": character,
                                       "dialogue": dialogue,
                                       "imageUrl": imageUrl,
                                       "audioUrl": audioUrl]
            
            COLLECTION_DIALOGUES.document(character).setData(data, completion: completion)
        }
    }
    
    static func fetchDialogue(completion: @escaping(([Dialogue]) -> Void)) {
        
        COLLECTION_DIALOGUES.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let dialogues = documents.map { Dialogue(dictionary: $0.data()) }
            completion(dialogues)
        }
    }
}
