import Foundation

// Această clasă este "creierul" care știe doar să genereze string-uri
class PasswordGenerator {
    
    static func generate(length: Double, useNumbers: Bool, useSymbols: Bool) -> String {
        // 1. Definim seturile de caractere
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?"
        
        var allowedChars = letters
        if useNumbers { allowedChars += numbers }
        if useSymbols { allowedChars += symbols }
        
        // 2. Generăm parola
        let charsArray = Array(allowedChars)
        var result = ""
        
        for _ in 0..<Int(length) {
            if let randomChar = charsArray.randomElement() {
                result.append(randomChar)
            }
        }
        
        return result
    }
}
