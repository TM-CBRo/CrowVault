import Foundation
import SwiftData

// --- CLASA NOUĂ PENTRU ISTORIC ---
@Model
final class PasswordHistoryItem {
    var encryptedPassword: Data
    var savedDate: Date
    
    init(encryptedPassword: Data, savedDate: Date = Date()) {
        self.encryptedPassword = encryptedPassword
        self.savedDate = savedDate
    }
}

// --- CLASA PRINCIPALĂ ACTUALIZATĂ ---
@Model
final class AccountItem {
    var title: String
    var username: String
    var encryptedPassword: Data
    var salt: Data
    var website: String?
    var createdDate: Date
    
    // Relația: Un cont are mai multe parole vechi
    // .cascade înseamnă că dacă ștergi contul, se șterge și istoricul
    @Relationship(deleteRule: .cascade) var history: [PasswordHistoryItem] = []
    
    init(title: String, username: String, encryptedPassword: Data, salt: Data, website: String? = nil) {
        self.title = title
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.salt = salt
        self.website = website
        self.createdDate = Date()
    }
}
