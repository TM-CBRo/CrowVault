import LocalAuthentication
import Foundation

class BiometricManager {
    static let shared = BiometricManager()
    
    private init() {}
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // 1. Verificăm dacă telefonul are hardware biometric (FaceID/TouchID)
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Scan your face to access the vault."
            
            // 2. Cerem scanarea
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                // Procesul se întâmplă pe un thread secundar, noi trebuie să răspundem pe cel Principal (UI)
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, "Authentication failed")
                    }
                }
            }
        } else {
            // Nu are FaceID setat sau nu are hardware
            completion(false, "The device does not have biometric set up.")
        }
    }
}
