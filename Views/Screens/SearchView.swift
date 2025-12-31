import SwiftUI
import SwiftData

struct SearchView: View {
    @Query(sort: \AccountItem.title) private var items: [AccountItem]
    @State private var searchText = ""
    
    // Logica de filtrare: Caută în Titlu SAU în Username
    var filteredItems: [AccountItem] {
        if searchText.isEmpty {
            return items // Dacă nu scrii nimic, arată toate conturile (sau poți returna [] pentru ecran gol)
        } else {
            return items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.username.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. FUNDAL
                AppBackground()
                
                VStack(spacing: 20) {
                    // --- CUSTOM SEARCH BAR ---
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.textSecondary)
                        
                        TextField("", text: $searchText, prompt: Text("Search account or email...").foregroundColor(Color.textSecondary))
                            .foregroundStyle(.white)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // --- LISTA REZULTATE ---
                    if filteredItems.isEmpty && !searchText.isEmpty {
                        // Caz: Nu s-a găsit nimic
                        VStack(spacing: 15) {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundStyle(Color.textSecondary.opacity(0.5))
                            Text("No results found for '\(searchText)'")
                                .foregroundStyle(Color.textSecondary)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    } else {
                        // Caz: Avem rezultate
                        List {
                            ForEach(filteredItems) { item in
                                ZStack {
                                    AccountRowView(item: item)
                                    
                                    // Navigare invizibilă către detalii
                                    NavigationLink(destination: AccountDetailView(item: item)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Search")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    SearchView()
}
