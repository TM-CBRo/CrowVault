import SwiftUI

extension Color {
    // Brandul (Albastru-Indigo vibrant)
    static let brandPrimary = Color(red: 0.25, green: 0.15, blue: 0.95)
    static let brandSecondary = Color(red: 0.40, green: 0.30, blue: 1.0)
    
    // Sticlă întunecată (pentru Carduri)
    static let cardBackground = Color(hex: "151525").opacity(0.6)
    
    // Text secundar (Gri deschis)
    static let textSecondary = Color(hex: "A0A0B0")
    
    // Helper Hex
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// --- AICI ERA PROBLEMA (Trebuie să fie separată de Color) ---
extension LinearGradient {
    static let brandGradient = LinearGradient(
        colors: [Color.brandPrimary, Color.brandSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Componenta de Fundal Globală
struct AppBackground: View {
    var body: some View {
        ZStack {
            Color(hex: "050510").ignoresSafeArea()
            
            // Lumini ambientale
            Circle().fill(Color.brandPrimary.opacity(0.3)).frame(width: 300).blur(radius: 100).offset(x: -100, y: -200)
            Circle().fill(Color.brandSecondary.opacity(0.2)).frame(width: 350).blur(radius: 120).offset(x: 150, y: 300)
        }
    }
}
