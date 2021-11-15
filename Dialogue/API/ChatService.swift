import Firebase

struct ConversationInfo {
    let conversations: [String]
    let members: [String]
    let dialogues: [String]
    let title: String
}

struct ChatService {
    
    static func uploadConversation(info: ConversationInfo, completion: @escaping((Error?) -> Void)) {
        
        let data: [String: Any] = ["audioUrls": info.conversations,
                                   "caracterImageUrls": info.members,
                                   "dialogs": info.dialogues,
                                   "title": info.title]
        
        COLLECTION_CONVERSATIONS.addDocument(data: data, completion: completion)
    }
    
    static func fetchConversation(completion: @escaping(( [Conversation] ) -> Void)) {
        
        COLLECTION_CONVERSATIONS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let conversations = documents.map { Conversation(dictionary: $0.data() )}
            completion(conversations)
        }
    }
}
