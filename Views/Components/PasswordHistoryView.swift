import SwiftUI

struct PasswordHistoryView: View {
    var historyItems: [PasswordHistoryItem]
    var salt: Data // Avem nevoie de sarea contului părinte pentru a decripta
    
    // Ca să putem închide fereastra
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if historyItems.isEmpty {
                    Text("There is no history for this account.")
                        .foregroundStyle(.gray)
                } else {
                    ForEach(historyItems.sorted(by: { $0.savedDate > $1.savedDate })) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.savedDate.formatted(date: .numeric, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                
                                // Afișăm parola decriptată (ascunsă cu buline inițial)
                                SecureRow(encryptedData: item.encryptedPassword, salt: salt)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Password History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Close") { dismiss() }
            }
        }
    }
}

// O componentă mică doar pentru rândurile din istoric
struct SecureRow: View {
    let encryptedData: Data
    let salt: Data
    @State private var isRevealed = false
    @State private var decryptedText = "••••••••"
    
    var body: some View {
        HStack {
            Text(isRevealed ? decryptedText : "••••••••")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(isRevealed ? .primary : .secondary)
            
            Spacer()
            
            Button(action: toggleReveal) {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .foregroundStyle(.blue)
            }
        }
        .onAppear {
            // Decriptăm o singură dată când apare rândul, dar nu arătăm încă
            decrypt()
        }
    }
    
    func toggleReveal() {
        withAnimation { isRevealed.toggle() }
    }
    
    func decrypt() {
        // Folosim logica existentă
        let key = CryptoManager.shared.deriveKey(password: "TEMPORARY_MASTER_PASSWORD", salt: salt)
        // NOTĂ: Dacă ai implementat Keychain, aici trebuie să iei parola reală,
        // dar pentru simplitate acum folosim mecanismul din AddItem
        
        if let data = try? CryptoManager.shared.decrypt(combinedData: encryptedData, key: key),
           let text = String(data: data, encoding: .utf8) {
            decryptedText = text
        }
    }
}
