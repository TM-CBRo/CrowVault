import Foundation
import SwiftUI

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    @AppStorage("isOnboarded") var isOnboarded: Bool = false
    @AppStorage("appUsername") var username: String = ""
    
    // Constante pentru Keychain
    private let service = "com.crowvault.keys"
    private let account = "master_password"
    
    private init() {}
    
    // --- 1. SIGN UP (Salvăm parola reală în Keychain) ---
    func createAccount(name: String, password: String) -> Bool {
        username = name
        isOnboarded = true
        
        // Convertim parola în date
        if let data = password.data(using: .utf8) {
            // SALVĂM SECURIZAT
            KeychainHelper.standard.save(data, service: service, account: account)
        }
        
        return true
    }
    
    // --- 2. VERIFICARE REALĂ ---
    func verifyPassword(_ inputPassword: String) -> Bool {
        // Citim parola salvată din cipul de securitate
        guard let data = KeychainHelper.standard.read(service: service, account: account),
              let savedPassword = String(data: data, encoding: .utf8) else {
            return false // Nu am găsit nicio parolă salvată
        }
        
        // Comparăm ce a scris userul cu ce e salvat
        return inputPassword == savedPassword
    }
    
    // --- 3. ȘTERGERE COMPLETĂ ---
    func deleteAccount() {
        isOnboarded = false
        username = ""
        // Ștergem și parola din Keychain
        KeychainHelper.standard.delete(service: service, account: account)
    }
    
    func logout() {
        NotificationCenter.default.post(name: NSNotification.Name("LockApp"), object: nil)
    }
}
