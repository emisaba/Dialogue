import UIKit
import AVFoundation

extension ChatViewController {
    func prepareAudio(num: Int) -> Bool {
        
        if num < audioUrls.count {
            do {
                let data = try Data(contentsOf: audioUrls[playNum])
                audio = try AVAudioPlayer(data: data)
                audio?.volume = 20
                audio?.delegate = self
                
                return true
                
            } catch {
                print("audip Error")
            }
        }
        return false
    }
}

// MARK: - AVAudioPlayerDelegate

extension ChatViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNum += 1
        
        if prepareAudio(num: playNum) {
            audio?.play()
        } else {
            playNum = 0
            topView.startButton.setImage(#imageLiteral(resourceName: "start"), for: .normal)
            topView.startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 15)
        }
    }
}

// MARK: - TopCellViewDelegate

extension ChatViewController: TopCellViewDelegate {
    
    func didTapStartButton(cell: TopCellContents) {
        if prepareAudio(num: playNum) {
            audio?.play()
            
            topView.startButton.setImage(#imageLiteral(resourceName: "square"), for: .normal)
            topView.startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
}
