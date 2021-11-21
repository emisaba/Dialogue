import UIKit

enum CellColorType: CaseIterable {
    case pink
    case blue
    case yellow
    case green
    case orange
    case purple
    
    var cellColor: UIColor {
        switch self {
        case .pink:
            return .customColor(red: 209, green: 45, blue: 67)
        case .blue:
            return .customColor(red: 48, green: 112, blue: 181)
        case .yellow:
            return .customColor(red: 242, green: 169, blue: 59)
        case .green:
            return .customColor(red: 87, green: 142, blue: 40)
        case .orange:
            return .customColor(red: 214, green: 91, blue: 38)
        case .purple:
            return .customColor(red: 112, green: 46, blue: 113)
        }
    }
    
    var chatViewMainColor: UIColor {
        switch self {
        case .pink:
            return .customColor(red: 160, green: 32, blue: 51)
        case .blue:
            return .customColor(red: 36, green: 86, blue: 139)
        case .yellow:
            return .customColor(red: 218, green: 152, blue: 52)
        case .green:
            return .customColor(red: 58, green: 95, blue: 24)
        case .orange:
            return .customColor(red: 164, green: 69, blue: 27)
        case .purple:
            return .customColor(red: 75, green: 30, blue: 75)
        }
    }
}
