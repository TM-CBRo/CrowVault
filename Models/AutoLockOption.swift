import Foundation

enum AutoLockOption: Int, CaseIterable, Identifiable {
    case immediately = 0
    case oneMinute = 60
    case twoMinutes = 120
    case fiveMinutes = 300
    case tenMinutes = 600
    case thirtyMinutes = 1800
    case never = -1
    
    var id: Int { self.rawValue }
    
    var displayName: String {
        switch self {
        case .immediately: return "Immediately"
        case .oneMinute: return "1 minute"
        case .twoMinutes: return "2 minutes"
        case .fiveMinutes: return "5 minutes"
        case .tenMinutes: return "10 minutes"
        case .thirtyMinutes: return "30 minutes"
        case .never: return "Never"

        }
    }
}
