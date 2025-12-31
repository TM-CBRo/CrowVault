import SwiftUI

struct WelcomeView: View {
    // Navigare
    @State private var showSignUp = false
    @State private var showLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Fundalul Premium
                OnboardingBackground()
                
                // 2. Conținutul
                VStack(spacing: 0) {
                    Spacer()
                    Spacer()
                    
                    // --- HERO SECTION (Logo & Text) ---
                    VStack(spacing: 20) {
                        // Iconița strălucitoare
                        ZStack {
                            Circle()
                                .fill(LinearGradient.brandGradient.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                            
                            Image(systemName: "shield.check.fill")
                                .font(.system(size: 70))
                                .foregroundStyle(LinearGradient.brandGradient)
                        }
                        
                        Text("CrowVault")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .brandPrimary.opacity(0.5), radius: 10)
                        
                        Text("Total Security.")
                            .font(.title3)
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    // --- ACTION SECTION (Butoane) ---
                    VStack(spacing: 16) {
                        // Buton Principal (Gradient)
                        Button(action: { showSignUp = true }) {
                            Text("Sign Up")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(LinearGradient.brandGradient)
                                .cornerRadius(18)
                                .shadow(color: .brandPrimary.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        
                        // Buton Secundar (Glassmorphism subtil)
                        Button(action: { showLogin = true }) {
                            Text("Sign In")
                                .font(.headline.weight(.semibold))
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                // Efect de sticlă
                                .background(.ultraThinMaterial.opacity(0.3))
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            // --- NAVIGARE (Funcționalitatea rămâne neatinsă) ---
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
