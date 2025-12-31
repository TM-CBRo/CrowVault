import SwiftUI

struct LoginView: View {
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showSuccess = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // 1. FOLOSIM NOUL FUNDAL "DEEP SPACE"
            AppBackground()
            
            VStack(spacing: 30) {
                // --- HEADER ---
                VStack(spacing: 15) {
                    ZStack {
                        // Halou
                        Circle()
                            .fill(LinearGradient.brandGradient.opacity(0.3))
                            .frame(width: 90, height: 90)
                            .blur(radius: 20)
                        
                        // Cerc sticlă
                        Circle()
                            .fill(.ultraThinMaterial.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        
                        Image(systemName: "lock.open.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    
                    Text("Welcome Back!")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white) // Text Alb
                    
                    Text("Enter Master Password to unlock the existing vault on this device.")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary) // Text Gri
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 50)
                
                // --- CÂMP PAROLĂ (STIL GLASS) ---
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundStyle(Color.textSecondary)
                        
                        SecureField("", text: $password, prompt: Text("Master Password").foregroundColor(Color.textSecondary.opacity(0.7)))
                            .foregroundStyle(.white)
                            .tint(.brandPrimary)
                    }
                    .padding()
                    .background(.ultraThinMaterial.opacity(0.2)) // Sticlă
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(errorMessage.isEmpty ? Color.white.opacity(0.1) : Color.red, lineWidth: 1)
                    )
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 24)
                
                // --- BUTON LOGIN (AICI AM REPARAT EROAREA) ---
                Button(action: performLogin) {
                    if showSuccess {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .foregroundStyle(.white)
                    } else {
                        Text("Open Vault")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                // REPARATIE: Folosim 'Group' cu if-else pentru a suporta tipuri diferite
                .background(
                    Group {
                        if password.isEmpty {
                            Color.gray.opacity(0.3)
                        } else {
                            LinearGradient.brandGradient
                        }
                    }
                )
                .cornerRadius(15)
                .shadow(color: password.isEmpty ? .clear : .brandPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 24)
                .disabled(password.isEmpty)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
                Spacer()
            }
        }
    }
    
    // --- LOGICA DE LOGIN ---
    func performLogin() {
        if AuthenticationManager.shared.verifyPassword(password) {
            // SUCCES!
            withAnimation { showSuccess = true }
            
            // Feedback Haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AuthenticationManager.shared.isOnboarded = true
            }
        } else {
            // EROARE
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            withAnimation {
                errorMessage = "Incorrect password or no saved account found."
            }
        }
    }
}

#Preview {
    LoginView()
}
