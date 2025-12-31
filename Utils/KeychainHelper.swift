import Foundation
import Security

class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}
    
    // Funcție pentru a salva parola
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Ștergem dacă există deja ceva vechi
        SecItemDelete(query)
        
        // Adăugăm noua parolă
        SecItemAdd(query, nil)
    }
    
    // Funcție pentru a citi parola
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
    
    // Funcție pentru a șterge parola din sistem
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
