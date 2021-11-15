import UIKit

extension CreateChatController: CustomAlertDelegate {
    
    // MARK: - Actions
    
    @objc func didTapRegisterButton() {
        UIView.animate(withDuration: 0.25) {
            self.alertBackgroundView.alpha = 1
            
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.customAlert.alpha = 1
                self.customAlertConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Helpers
    
    func dismissAlerView() {
        UIView.animate(withDuration: 0.25) {
            self.customAlert.alpha = 0
            self.customAlertConstraint?.isActive = false
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
            
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.alertBackgroundView.alpha = 0
            }
        }
    }
    
    // MARK: - CustomAlertDelegate
    
    func registerTitle(view: CustomAlert) {
        
        guard let title = view.textView.text else { return }
        let members = conversationBottomView.convarsations.map { $0.imageUrl }
        let dialogues = conversationBottomView.convarsations.map { $0.dialogue }
        
        uploadConversation(title: title, members: members, dialogues: dialogues)
    }
}
