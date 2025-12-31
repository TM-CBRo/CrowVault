import SwiftUI

// Componentă reutilizabilă pentru fundalul modern de onboarding
struct OnboardingBackground: View {
    var body: some View {
        ZStack {
            // 1. Baza foarte închisă (aproape negru, dar cu o tentă de albastru)
            Color(hex: "050510").ignoresSafeArea()
            
            // 2. Orbe de lumină difuză pentru atmosferă
            // O lumină albastră sus-stânga
            Circle()
                .fill(Color.brandPrimary.opacity(0.4))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(x: -100, y: -200)
            
            // O lumină purpurie jos-dreapta
            Circle()
                .fill(Color.brandSecondary.opacity(0.3))
                .frame(width: 350)
                .blur(radius: 120)
                .offset(x: 150, y: 300)
        }
    }
}

#Preview {
    OnboardingBackground()
}
