import Foundation
import SwiftData
import CryptoKit

@Observable
class AddItemViewModel {
    
    // --- Variabile UI ---
    var title: String = ""
    var username: String = ""
    var password: String = ""
    var website: String = ""
    
    // --- Configurare Generator ---
    var passwordLength: Double = 12
    var includeNumbers: Bool = true
    var includeSpecialChars: Bool = true
    
    // --- LOGICA DE VALIDARE PAROLĂ  ---
    
    // 1. Verificăm regulile individuale
    var hasMinLength: Bool { password.count >= 8 }
    var hasUppercase: Bool { password.contains { $0.isUppercase } }
    var hasSymbol: Bool {
        let symbols = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:,.<>?")
        return password.rangeOfCharacter(from: symbols) != nil
    }
    
    // 2. Este parola complet validă?
    var isPasswordValid: Bool {
        // Dacă e goală, nu e validă, dar nici nu dăm erori încă
        if password.isEmpty { return false }
        return hasMinLength && hasUppercase && hasSymbol
    }
    
    // 3. Mesajul de avertizare (Warning)
    var passwordWarningMessage: String? {
        if password.isEmpty { return nil } // Nu arătăm erori dacă nu a scris nimic încă
        if isPasswordValid { return nil } // Dacă e validă, nu avem erori
        
        var errors = [String]()
        if !hasMinLength { errors.append("min 8 characters") }
        if !hasUppercase { errors.append("an uppercase letter") }
        if !hasSymbol { errors.append("a simbol") }
        
        return "Missing: " + errors.joined(separator: ", ")
    }
    
    // --- RESTUL FUNCȚIILOR (Generator & Save) RĂMÂN LA FEL ---
    
    func generateRandomPassword() {
        self.password = PasswordGenerator.generate(
            length: passwordLength,
            useNumbers: includeNumbers,
            useSymbols: includeSpecialChars
        )
    }
    
    func saveItem(modelContext: ModelContext) {
        // ... (Codul de salvare existent - neschimbat)
        guard !title.isEmpty, !password.isEmpty else { return }
        let salt = generateRandomSalt()
        let key = CryptoManager.shared.deriveKey(password: "TEMPORARY_MASTER_PASSWORD", salt: salt)
        
        do {
            let passwordData = Data(password.utf8)
            let encryptedData = try CryptoManager.shared.encrypt(data: passwordData, key: key)
            
            let newItem = AccountItem(
                title: title,
                username: username,
                encryptedPassword: encryptedData,
                salt: salt,
                website: website.isEmpty ? nil : website
            )
            
            modelContext.insert(newItem)
            clearFields()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func generateRandomSalt() -> Data {
        var salt = Data(count: 32)
        _ = salt.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) }
        return salt
    }
    
    private func clearFields() {
        title = ""
        username = ""
        password = ""
        website = ""
    }
}
