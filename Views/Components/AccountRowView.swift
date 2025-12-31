import SwiftUI

struct AccountRowView: View {
    let item: AccountItem
    
    var body: some View {
        HStack(spacing: 15) {
            // Icoana
            ZStack {
                Circle()
                    .fill(LinearGradient.brandGradient)
                    .frame(width: 48, height: 48)
                    .shadow(color: .brandPrimary.opacity(0.5), radius: 8, x: 0, y: 0) // Glow mai puternic
                
                Text(item.title.prefix(1).uppercased())
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            
            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white) // Text Alb
                
                Text(item.username)
                    .font(.subheadline)
                    .foregroundColor(Color.textSecondary) // Text Gri deschis
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color.textSecondary)
        }
        .padding()
        // --- STIL GLASS ---
        .background(.ultraThinMaterial.opacity(0.1)) // Sticlă foarte fină
        .background(Color.cardBackground) // Tentă de culoare închisă
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1) // Contur fin
        )
    }
}
