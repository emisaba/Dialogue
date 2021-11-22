import UIKit
import AVFoundation

extension CreateChatController: AVAudioPlayerDelegate {
    
    // MARK: - Action
    
    @objc func didTapStartButton() {
        selectedAudios = []
        selectedAudiosUrlString = []
        
        conversationBottomView.convarsations.forEach { dialogue in
            selectedAudiosUrlString.append(dialogue.audioUrl)
            
            guard let url = URL(string: dialogue.audioUrl) else { return }
            selectedAudios.append(url)
        }
        startPlay()
    }
    
    // MARK: - Helpers
    
    func prepare(num: Int) -> Bool {
        if playNum < selectedAudios.count {
            do {
                let data = try Data(contentsOf: selectedAudios[playNum])
                audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer?.volume = 20
                audioPlayer?.delegate = self
                return true
            } catch {
                print("failed to start audio")
            }
        }
        return false
    }
    
    func startPlay() {
        if prepare(num: playNum) {
            audioPlayer?.play()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNum += 1
        
        if prepare(num: playNum) {
            audioPlayer?.play()
        }
    }
}
