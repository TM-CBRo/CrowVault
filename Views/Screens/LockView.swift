import SwiftUI

struct LockView: View {
    var onUnlock: () -> Void // Funcție pe care o apelăm când reușește
    
    var body: some View {
        ZStack {
            // 1. Același Fundal Premium "Deep Space"
            OnboardingBackground()
            
            VStack {
                Spacer()
                
                // --- HERO SECTION (Lacătul Strălucitor) ---
                VStack(spacing: 25) {
                    ZStack {
                        // Halou luminos în spate
                        Circle()
                            .fill(LinearGradient.brandGradient.opacity(0.3))
                            .frame(width: 140, height: 140)
                            .blur(radius: 30)
                        
                        // Cercul de sticlă
                        Circle()
                            .fill(.ultraThinMaterial.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle()
                                    .stroke(LinearGradient.brandGradient.opacity(0.5), lineWidth: 1)
                            )
                        
                        // Icoana
                        Image(systemName: "lock.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                            .shadow(color: .brandPrimary, radius: 10)
                    }
                    
                    VStack(spacing: 8) {
                        Text("CrowVault")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("The vault is secure")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                
                Spacer()
                
                // --- BUTON DEBLOCARE (Stil Glass) ---
                Button(action: authenticate) {
                    HStack(spacing: 15) {
                        Image(systemName: "faceid")
                            .font(.title2)
                        Text("unlock with FaceID")
                            .font(.headline.weight(.semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    // Efect de sticlă înghețată
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    // Contur fin gradient
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(LinearGradient.brandGradient.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Încercăm automat când apare ecranul
            authenticate()
        }
    }
    
    func authenticate() {
        BiometricManager.shared.authenticateUser { success, error in
            if success {
                onUnlock() // Anunțăm aplicația că am intrat!
            }
        }
    }
}

#Preview {
    LockView(onUnlock: {})
}
