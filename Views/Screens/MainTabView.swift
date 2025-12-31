import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // TAB 1: SEIF
            DashboardView()
                .tabItem {
                    Label("Vault", systemImage: "lock.square.stack.fill")
                }
            
            // TAB 2: CĂUTARE
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // TAB 3: GENERATOR
            GeneratorView()
                .tabItem {
                    Label("Generator", systemImage: "key.horizontal.fill")
                }
            
            // TAB 4: SETĂRI
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        // Customizare Tab Bar pentru Dark Mode
        .tint(Color.brandPrimary) // Culoarea iconiței active
    }
}

#Preview {
    MainTabView()
}
