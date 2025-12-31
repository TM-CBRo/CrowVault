import SwiftUI
import SwiftData

@main
struct PasswordManagerApp: App {
    // ... variabilele tale (isOnboarded, etc.) ...
    @AppStorage("isOnboarded") var isOnboarded: Bool = false
    @State private var isUnlocked = false
    
    // Auto-Lock
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("autoLockSeconds") var autoLockSeconds: Int = 0
    @State private var lastBackgroundDate: Date?

    var body: some Scene {
        WindowGroup {
            // Începutul conținutului VIZUAL (View)
            ZStack {
                if !isOnboarded {
                    WelcomeView()
                } else {
                    if isUnlocked {
                        MainTabView()
                    } else {
                        LockView {
                            isUnlocked = true
                        }
                    }
                }
            }
            // --- MODIFICATORII TREBUIE SĂ FIE AICI (Atașați de ZStack) ---
            
            // 1. FORȚĂM DARK MODE (AICI ESTE REPARAȚIA) ✅
            .preferredColorScheme(.dark)
            
            // 2. Logică Auto-Lock
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .background {
                    lastBackgroundDate = Date()
                }
                if newPhase == .active {
                    checkAutoLock()
                }
            }
            // 3. Logică Logout
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LockApp"))) { _ in
                withAnimation {
                    isUnlocked = false
                }
            }
        }
        // Modificatorii de SCENE (baza de date) rămân în afara WindowGroup
        .modelContainer(for: AccountItem.self)
    }
    
    // ... funcția checkAutoLock() ...
    func checkAutoLock() {
        if autoLockSeconds == -1 { return }
        if let lastDate = lastBackgroundDate {
            let timeElapsed = Date().timeIntervalSince(lastDate)
            if Int(timeElapsed) >= autoLockSeconds {
                isUnlocked = false
            }
            lastBackgroundDate = nil
        }
    }
}
