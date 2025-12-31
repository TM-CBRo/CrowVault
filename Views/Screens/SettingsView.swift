import SwiftUI
import SwiftData

struct SettingsView: View {
    // Acces la baza de date (pentru ștergere)
    @Environment(\.modelContext) private var modelContext
    
    // Setarea de timp salvată în telefon
    @AppStorage("autoLockSeconds") var autoLockSeconds: Int = 0 // Default: Imediat
    
    // Stări pentru UI
    @State private var showDeleteAlert = false
    @State private var showPasswordCheck = false
    @State private var passwordInput = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. FUNDALUL "DEEP SPACE"
                AppBackground()
                
                // 2. LISTA TRANSPARENTĂ
                List {
                    // --- SECȚIUNEA 1: SECURITATE ---
                    Section(header: Text("Security").foregroundStyle(.white)) {
                        Picker("Auto Lock", selection: $autoLockSeconds) {
                            ForEach(AutoLockOption.allCases) { option in
                                Text(option.displayName).tag(option.rawValue)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .foregroundStyle(.white) // Textul picker-ului alb
                    }
                    .listRowBackground(Color.cardBackground) // <--- FACE RÂNDUL DARK/GLASS
                    
                    // --- SECȚIUNEA 2: CONT ---
                    Section(header: Text("Account").foregroundStyle(.white)) {
                        // Buton LOG OUT
                        Button(action: {
                            AuthenticationManager.shared.logout()
                        }) {
                            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.blue)
                        }
                        
                        // Buton DELETE ACCOUNT (Roșu)
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Label("Delete Account", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    .listRowBackground(Color.cardBackground) // <--- FACE RÂNDUL DARK/GLASS
                    
                    // --- FOOTER ---
                    Section {
                                        VStack(spacing: 6) {
                                            Text("CrowVault © 2025")
                                                .font(.caption.bold()) // Titlul puțin mai gros
                                                .foregroundStyle(.white.opacity(0.9))
                                            
                                            Text("Version: 1.0.0")
                                                .font(.caption2)
                                                .foregroundStyle(Color.textSecondary)
                                            
                                            Text("Developed by: Andresoi Timotei")
                                                .font(.caption2)
                                                .foregroundStyle(Color.textSecondary)
                                            
                                            Text("All Rights Reserved.")
                                                .font(.caption2)
                                                .foregroundStyle(Color.textSecondary)
                                        }
                                        .frame(maxWidth: .infinity) // Forțează centrarea pe tot ecranul
                                        .multilineTextAlignment(.center)
                                        .listRowBackground(Color.clear) // Transparent, fără fundal de card
                                        .padding(.top, 10)
                                    }                }
                .scrollContentBackground(.hidden) // <--- ASTA FACE LISTA TRANSPARENTĂ
                .background(Color.clear)
            }
            .navigationTitle("Settings")
            // Schimbăm culoarea titlului mare de navigare în alb (pentru dark mode forțat)
            .toolbarColorScheme(.dark, for: .navigationBar)
            
            // --- ALERTĂ CONFIRMARE ȘTERGERE ---
            .alert("ATTENTION", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Continue", role: .destructive) {
                    showPasswordCheck = true // Deschidem verificarea parolei
                }
            } message: {
                Text("Warning: Are you sure you want to permanently delete your account? This action is irreversible and cannot be undone.")
            }
            
            // --- FEREASTRA DE VERIFICARE PAROLĂ (Sheet) ---
            .sheet(isPresented: $showPasswordCheck) {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)
                    
                    Text("Final Confirmation")
                        .font(.title)
                        .bold()
                    
                    Text("Enter Master Password to confirm permanent deletion.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    SecureField("Master Password", text: $passwordInput)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage).foregroundStyle(.red)
                    }
                    
                    Button(action: performDeleteAccount) {
                        Text("CONFIRM ACCOUNT DELETION")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(passwordInput.isEmpty)
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    // --- LOGICA DE ȘTERGERE ---
    func performDeleteAccount() {
        let isPasswordCorrect = AuthenticationManager.shared.verifyPassword(passwordInput)
        
        if !isPasswordCorrect {
            errorMessage = "The Master Password is incorrect!"
            return
        }
        
        do {
            try modelContext.delete(model: AccountItem.self)
        } catch {
            print("Error deleting data: \(error)")
        }
        
        AuthenticationManager.shared.deleteAccount()
        showPasswordCheck = false
    }
}

#Preview {
    SettingsView()
}
