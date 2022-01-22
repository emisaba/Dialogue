import UIKit

extension CreateChatController: CharacterListViewDelegate {
    func selectCharacter(character: Character) {
        selectedCharacter = character
        updateDialogues(character: character)
        dialogueListDescription.isHidden = true
        addDialogueButton.isHidden = false
    }
    
    func showRegisterViewController() {
        let vc = RegisterViewController()
        vc.completion = { newInfo in
            self.updateCharacter(newInfo: newInfo)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
