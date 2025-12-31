import Foundation
import CryptoKit

final class CryptoManager {
    
    static let shared = CryptoManager()
    
    private init() {}
    
    // 1. Derivarea Cheii (Folosind HKDF - Nativ Swift)
    // HKDF este modern și nu necesită configurări vechi de C
    func deriveKey(password: String, salt: Data) -> SymmetricKey {
        
        // Convertim parola în date
        let inputKeyMaterial = SymmetricKey(data: password.data(using: .utf8)!)
        
        // Folosim HKDF pentru a expanda parola într-o cheie sigură de 32 bytes (256 biți)
        let derivedKey = HKDF<SHA256>.deriveKey(
            inputKeyMaterial: inputKeyMaterial,
            salt: salt,
            info: Data(), // Context opțional, putem lăsa gol
            outputByteCount: 32
        )
        
        return derivedKey
    }
    
    // 2. Criptarea (AES-GCM) - Rămâne neschimbată
    func encrypt(data: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    // 3. Decriptarea (AES-GCM) - Rămâne neschimbată
    func decrypt(combinedData: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return decryptedData
    }
}
