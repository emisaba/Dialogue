import UIKit

struct RegisterViewModel {
    let pageNumber: Int
    
    var shouldHideName: Bool {
        return pageNumber == 1 || pageNumber == 2
    }
    
    var shouldHideImage: Bool {
        return pageNumber == 0 || pageNumber == 2
    }
    
    var shouldHideAudio: Bool {
        return pageNumber == 0 || pageNumber == 1
    }
    
    init(pageNumber: Int) {
        self.pageNumber = pageNumber
    }
}
