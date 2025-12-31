import SwiftUI

struct GeneratorView: View {
    @State private var password = ""
    @State private var length: Double = 12
    @State private var useNumbers = true
    @State private var useSymbols = true
    @State private var showCopiedAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. FUNDALUL "DEEP SPACE"
                AppBackground()
                
                VStack(spacing: 25) {
                    // --- 1. CARDUL HERO (Parola) ---
                    VStack(spacing: 15) {
                        Text(password)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white) // Text ALB pe fundal dark
                            // Animație la schimbarea textului
                            .contentTransition(.numericText())
                            .animation(.snappy, value: password)
                        
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Tap to copy")
                        }
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary) // Gri deschis
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    // --- STIL GLASS ---
                    .background(.ultraThinMaterial.opacity(0.1)) // Material fin
                    .background(Color.cardBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1) // Contur fin
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    .onTapGesture {
                        copyToClipboard()
                    }
                    
                    // --- 2. CONFIGURARE ---
                    VStack(spacing: 0) {
                        // Slider Row
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Length")
                                    .foregroundStyle(.white) // Text Alb
                                Spacer()
                                Text("\(Int(length))")
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(Color.brandPrimary)
                            }
                            
                            Slider(value: $length, in: 5...30, step: 1)
                                .tint(Color.brandPrimary)
                                .onChange(of: length) { _, _ in generate() }
                        }
                        .padding()
                        
                        Divider().background(Color.white.opacity(0.1)) // Divider subtil
                        
                        // Toggles
                        ToggleRow(title: "Include Digits (0-9)", isOn: $useNumbers)
                        
                        Divider()
                            .padding(.leading)
                            .background(Color.white.opacity(0.1))
                        
                        ToggleRow(title: "Include Symbols (@#$)", isOn: $useSymbols)
                    }
                    // --- STIL GLASS CONFIGURARE ---
                    .background(.ultraThinMaterial.opacity(0.1))
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                    
                    Spacer()
                    
                    // --- 3. BUTON REGENERARE MARE ---
                    Button(action: generate) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Generate New Password")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(LinearGradient.brandGradient)
                        .cornerRadius(16)
                        .shadow(color: .brandPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Generator")
            .onAppear(perform: generate)
            
            // Overlay Alerta
            .overlay(
                Group {
                    if showCopiedAlert {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Copied to Clipboard")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(30)
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.bottom, 60)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }, alignment: .bottom
            )
        }
        // Helper pentru onChange
        .onChange(of: useNumbers) { _, _ in generate() }
        .onChange(of: useSymbols) { _, _ in generate() }
    }
    
    // Componentă mică pentru rândurile Toggle
    func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .foregroundStyle(.white) // Asigurăm că textul e alb
        }
        .toggleStyle(SwitchToggleStyle(tint: .brandPrimary))
        .padding()
    }
    
    // Logica (neschimbată)
    func generate() {
        password = PasswordGenerator.generate(length: length, useNumbers: useNumbers, useSymbols: useSymbols)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = password
        withAnimation { showCopiedAlert = true }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showCopiedAlert = false }
        }
    }
}
