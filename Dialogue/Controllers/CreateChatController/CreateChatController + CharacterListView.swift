import UIKit

extension CreateChatController: CharacterListViewDelegate {
    
    func selectCharacter(dialogues: [Dialogue]) {
        dialoguesBySelectedCharacter = dialogues
        selectedCharacter = dialogues[0]
        dialogueListView.reloadData()
    }
    
    func showRegisterViewController() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchCharacter() {
        fetchDialogue()
    }
}
