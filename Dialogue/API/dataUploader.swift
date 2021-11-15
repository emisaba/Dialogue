import FirebaseStorage

struct DialogueItem {
    let image: UIImage
    let audio: URL
    let text: String
    let character: String
}

struct DownloadURL {
    let image: String
    let audio: String
}

struct DataUploader {
    
    static func uploadDialogue(dialogueItem: DialogueItem, completion: @escaping((DownloadURL) -> Void)) {
        
        guard let image = dialogueItem.image.jpegData(compressionQuality: 0.75) else { return }
        let audio = dialogueItem.audio
        let filename = UUID().uuidString
        
        let imageRef = Storage.storage().reference(withPath: "image/\(filename)")
        let audioRef = Storage.storage().reference(withPath: "audio/\(filename)")
        
        imageRef.putData(image, metadata: nil) { _, _ in
            imageRef.downloadURL { url, _ in
                guard let imageUrl = url?.absoluteString else { return }
                
                audioRef.putFile(from: audio, metadata: nil) { _, _ in
                    audioRef.downloadURL { url, _ in
                        guard let audioUrl = url?.absoluteString else { return }
                        
                        completion(DownloadURL(image: imageUrl, audio: audioUrl))
                    }
                }
            }
        }
    }
}
