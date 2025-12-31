import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    // Pentru a ascunde tastatura când dăm tap în exterior
    @FocusState private var focusedField: Field?
    enum Field { case name, password, confirm }
    
    var body: some View {
        ZStack {
            // 1. Același Fundal Premium
            OnboardingBackground()
                .onTapGesture { focusedField = nil } // Ascunde tastatura
            
            VStack(spacing: 30) {
                // --- HEADER ---
                VStack(spacing: 10) {
                    Text("Create Vault")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Your data is encrypted locally. \nWe cannot see it..")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 30)
                
                // --- FORMULAR GLASS ---
                VStack(spacing: 20) {
                    
                    // Câmp Nume Customizat
                    GlassTextField(icon: "person.fill", placeholder: "Your Username", text: $fullName)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                    
                    // Câmp Parolă Customizat
                    GlassSecureField(icon: "lock.fill", placeholder: "Master Password", text: $password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                    
                    // Câmp Confirmare
                    GlassSecureField(icon: "lock.shield.fill", placeholder: "Confirm Password", text: $confirmPassword)
                        .focused($focusedField, equals: .confirm)
                        .submitLabel(.done)
                    
                    // Mesaj Eroare
                    if !errorMessage.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(errorMessage)
                        }
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color(hex: "FF453A")) // Un roșu modern
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // --- BUTON ACTIUNE ---
                Button(action: createAccount) {
                    Text("Activate CrowVault ")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        // Butonul devine gri dacă nu e gata
                        .background(isFormValid ? LinearGradient.brandGradient : LinearGradient(colors: [.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(18)
                        .shadow(color: isFormValid ? .brandPrimary.opacity(0.4) : .clear, radius: 10, y: 5)
                        .animation(.easeInOut, value: isFormValid)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .disabled(!isFormValid)
            }
        }
    }
    
    // --- LOGICA (Rămâne la fel) ---
    var isFormValid: Bool {
        !fullName.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func createAccount() {
        if password != confirmPassword {
            withAnimation { errorMessage = "The passwords do not match." }
            return
        }
        if password.count < 6 {
            withAnimation { errorMessage = "The Master password is too short (minimum 6 characters)." }
            return
        }
        
        // Feedback Haptic la succes
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        _ = AuthenticationManager.shared.createAccount(name: fullName, password: password)
    }
}

// --- COMPONENTE AUXILIARE DE DESIGN (TextFields Moderne) ---

// Câmp text normal cu stil "Glass"
struct GlassTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 24)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.textSecondary.opacity(0.7)))
                .foregroundStyle(.white)
                .tint(.brandPrimary) // Culoarea cursorului
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.2)) // Sticlă foarte fină
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// Câmp parolă cu stil "Glass"
struct GlassSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 24)
            
            SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.textSecondary.opacity(0.7)))
                .foregroundStyle(.white)
                .tint(.brandPrimary)
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    SignUpView()
}
