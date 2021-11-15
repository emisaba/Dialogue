import UIKit

extension CreateChatController: CharacterListViewDelegate {
    
    func selectCharacter(dialogues: [Dialogue]) {
        dialoguesBySelectedCharacter = dialogues
        tableView.reloadData()
    }
    
    func showRegisterViewController() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchCharacter() {
        fetchDialogue()
    }
}
