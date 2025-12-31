import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AddItemViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. FUNDAL DEEP SPACE
                AppBackground()
                
                // 2. FORMULAR TRANSPARENT
                Form {
                    Section(header: Text("Account details").foregroundStyle(.white)) {
                        
                        // --- AICI SUNT MODIFICĂRILE PENTRU PLACEHOLDER ---
                        TextField("", text: $viewModel.title, prompt: Text("Platform Name").foregroundColor(Color.textSecondary))
                            .foregroundStyle(.white) // Textul scris de tine e ALB
                        
                        TextField("", text: $viewModel.username, prompt: Text("Email/Username").foregroundColor(Color.textSecondary))
                            .textInputAutocapitalization(.never)
                            .foregroundStyle(.white)
                        
                        TextField("", text: $viewModel.website, prompt: Text("Website").foregroundColor(Color.textSecondary))
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    Section(header: Text("Sensitive Information").foregroundStyle(.white)) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                // --- MODIFICARE PLACEHOLDER PAROLĂ ---
                                SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundColor(Color.textSecondary))
                                    .foregroundStyle(.white)
                                
                                Button(action: { viewModel.generateRandomPassword() }) {
                                    Image(systemName: "die.face.5.fill").foregroundColor(.brandPrimary)
                                }
                                .buttonStyle(.borderless)
                            }
                            if let warning = viewModel.passwordWarningMessage {
                                Text(warning).font(.caption).foregroundStyle(.red).bold()
                            }
                        }
                        
                        DisclosureGroup("Generator Options") {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("lenght: \(Int(viewModel.passwordLength))").foregroundStyle(.white)
                                    Slider(value: $viewModel.passwordLength, in: 8...30, step: 1).tint(.brandPrimary)
                                }
                                Toggle("Digits", isOn: $viewModel.includeNumbers).foregroundStyle(.white)
                                Toggle("Symbols", isOn: $viewModel.includeSpecialChars).foregroundStyle(.white)
                            }
                        }
                        .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    Section {
                        Button(action: {
                            viewModel.saveItem(modelContext: modelContext)
                            dismiss()
                        }) {
                            Text("Save Password").bold().foregroundStyle(.white).frame(maxWidth: .infinity)
                        }
                        .listRowBackground(LinearGradient.brandGradient)
                        .disabled(viewModel.title.isEmpty || !viewModel.isPasswordValid)
                    }
                    
                    if !viewModel.isPasswordValid && !viewModel.password.isEmpty {
                        Section {
                            Text("Password must be at least 8 characters long, contain an uppercase letter, and a symbol.")
                                .font(.caption).foregroundStyle(Color.textSecondary)
                                .listRowBackground(Color.clear)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .navigationTitle("Add Account")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundStyle(.white)
                }
            }
        }
    }
}
