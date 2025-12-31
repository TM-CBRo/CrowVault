import SwiftUI
import SwiftData

struct AccountDetailView: View {
    @Bindable var item: AccountItem
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Stări UI
    @State private var isEditing = false
    @State private var showHistory = false
    @State private var isPasswordVisible = false
    @State private var decryptedPasswordCache = ""
    
    // Câmp temporar pentru parola nouă în timpul editării
    @State private var tempPasswordInput = ""
    
    var body: some View {
        ZStack {
            // 1. FUNDAL DEEP SPACE
            AppBackground()
            
            // 2. FORMULAR TRANSPARENT
            Form {
                // --- SECȚIUNEA 1: INFORMAȚII ---
                Section(header: Text("Information").foregroundStyle(.white)) {
                    if isEditing {
                        // Placeholders customizate
                        TextField("", text: $item.title, prompt: Text("Platform").foregroundColor(Color.textSecondary))
                            .foregroundStyle(.white)
                        
                        TextField("", text: $item.username, prompt: Text("Username").foregroundColor(Color.textSecondary))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(.white)
                        
                        TextField("", text: Binding(
                            get: { item.website ?? "" },
                            set: { item.website = $0.isEmpty ? nil : $0 }
                        ), prompt: Text("Website").foregroundColor(Color.textSecondary))
                        .foregroundStyle(.white)
                        
                    } else {
                        HStack {
                            Text("Platform").foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text(item.title).foregroundStyle(.white)
                        }
                        
                        HStack {
                            Text("Username").foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text(item.username).foregroundStyle(.white)
                        }
                        
                        if let site = item.website {
                            Link(destination: URL(string: site) ?? URL(string: "https://google.com")!) {
                                Label("Open Website", systemImage: "safari")
                                    .foregroundStyle(Color.brandPrimary)
                            }
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)
                
                // --- SECȚIUNEA 2: PAROLA ---
                Section(header: Text("Security").foregroundStyle(.white)) {
                    if isEditing {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password (leave blank to keep current)")
                                .font(.caption)
                                .foregroundStyle(Color.textSecondary)
                            
                            HStack {
                                // --- MODIFICARE PLACEHOLDER PAROLĂ NOUĂ ---
                                SecureField("", text: $tempPasswordInput, prompt: Text("Enter new password").foregroundColor(Color.textSecondary))
                                    .textContentType(.newPassword)
                                    .foregroundStyle(.white)
                                
                                Divider().background(Color.white.opacity(0.3)).frame(height: 20)
                                
                                Button(action: {
                                    tempPasswordInput = PasswordGenerator.generate(length: 16, useNumbers: true, useSymbols: true)
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                }) {
                                    HStack {
                                        Image(systemName: "die.face.5.fill")
                                        Text("Generate")
                                            .font(.caption).bold()
                                    }
                                    .foregroundStyle(Color.brandPrimary)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    } else {
                        // --- MOD VIZUALIZARE ---
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Password (Tap for history)")
                                    .font(.caption).foregroundStyle(Color.textSecondary)
                                
                                if isPasswordVisible {
                                    Text(decryptedPasswordCache)
                                        .font(.system(.body, design: .monospaced))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("••••••••••••")
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { showHistory = true }
                            
                            Spacer()
                            
                            HStack(spacing: 15) {
                                Button(action: revealPassword) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundStyle(Color.brandPrimary)
                                }
                                
                                Button(action: {
                                    if decryptedPasswordCache.isEmpty { revealPassword() }
                                    UIPasteboard.general.string = decryptedPasswordCache
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)
                
                // --- SECȚIUNEA 3: META ---
                if !isEditing {
                    Section {
                        HStack {
                            Text("Created at:")
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                            Text(item.createdDate.formatted(date: .abbreviated, time: .shortened))
                                .foregroundStyle(.white)
                        }
                        .font(.caption)
                    }
                    .listRowBackground(Color.cardBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .navigationTitle(item.title)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleEditMode) {
                    Text(isEditing ? "Save" : "Edit")
                        .bold()
                }
            }
        }
        .sheet(isPresented: $showHistory) {
            PasswordHistoryView(historyItems: item.history, salt: item.salt)
                .presentationDetents([.medium, .large])
        }
    }
    
    // --- LOGICA ---
    func toggleEditMode() {
        if isEditing { saveChanges() }
        isEditing.toggle()
    }
    
    func saveChanges() {
        if !tempPasswordInput.isEmpty {
            let oldHistoryItem = PasswordHistoryItem(encryptedPassword: item.encryptedPassword)
            item.history.append(oldHistoryItem)
            
            let key = CryptoManager.shared.deriveKey(password: "TEMPORARY_MASTER_PASSWORD", salt: item.salt)
            if let newData = try? CryptoManager.shared.encrypt(data: Data(tempPasswordInput.utf8), key: key) {
                item.encryptedPassword = newData
            }
            tempPasswordInput = ""
            decryptedPasswordCache = ""
            isPasswordVisible = false
        }
    }
    
    func revealPassword() {
        if isPasswordVisible {
            isPasswordVisible = false
            return
        }
        let key = CryptoManager.shared.deriveKey(password: "TEMPORARY_MASTER_PASSWORD", salt: item.salt)
        if let data = try? CryptoManager.shared.decrypt(combinedData: item.encryptedPassword, key: key),
           let text = String(data: data, encoding: .utf8) {
            decryptedPasswordCache = text
            isPasswordVisible = true
        }
    }
}
