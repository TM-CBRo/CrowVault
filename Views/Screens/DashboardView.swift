import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \AccountItem.createdDate, order: .reverse) private var items: [AccountItem]
    @State private var showAddItemSheet = false
    @AppStorage("appUsername") var username: String = "Username"
    @Environment(\.modelContext) private var modelContext

    var body: some View {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) { // Aliniem elementele jos-dreapta
                    
                    // 1. FUNDAL
                   AppBackground()
                    
                    // 2. CONȚINUT
                    if items.isEmpty {
                        // --- EMPTY STATE CENTRAT ---
                        VStack(spacing: 25) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 120, height: 120)
                                    .shadow(color: .black.opacity(0.05), radius: 10)
                                
                                Image(systemName: "shield.slash.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(Color.brandPrimary.opacity(0.4))
                            }
                            
                            VStack(spacing: 8) {
                                Text("No saved account")
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.primary)
                                
                                Text("Your data will be encrypted and stored\nhere safely.")
                                    .font(.body)
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // <--- ASTA ÎL CENTREAZĂ PERFECT
                        .offset(y: -50) // Îl ridicăm puțin vizual ca să nu fie fix în centru geometric
                        
                    } else {
                        List {
                                                // Header
                                                Group {
                                                    Text("Your Accounts")
                                                        .font(.system(size: 18, weight: .bold))
                                                        .foregroundStyle(Color.textSecondary)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .padding(.top, 10)
                                                        .padding(.bottom, 5)
                                                }
                                                .listRowSeparator(.hidden)
                                                .listRowBackground(Color.clear)
                                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                                
                                                // Lista Carduri
                                                ForEach(items) { item in
                                                    ZStack {
                                                        AccountRowView(item: item)
                                                        NavigationLink(destination: AccountDetailView(item: item)) {
                                                            EmptyView()
                                                        }
                                                        .opacity(0)
                                                    }
                                                    .listRowBackground(Color.clear)
                                                    .listRowSeparator(.hidden)
                                                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                                }
                                                .onDelete(perform: deleteItems)
                                                
                                                // --- REPARATIA ESTE AICI ---
                                                Rectangle()
                                                    .fill(.clear)
                                                    .frame(height: 80)
                                                    .listRowBackground(Color.clear)
                                                    .listRowSeparator(.hidden) // <--- 1. Ascunde linia de deasupra dreptunghiului
                                            }
                                            .listStyle(.plain)
                                            .scrollContentBackground(.hidden)
                                            .listSectionSeparator(.hidden)
                    }
                    
                    // --- 3. BUTONUL (+) PLUTITOR ---
                    // Îl punem direct în ZStack, nu ca overlay, pentru a fi sigur apăsabil
                    Button(action: { showAddItemSheet = true }) {
                        Image(systemName: "plus")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(LinearGradient.brandGradient)
                                    .shadow(color: .brandPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30) // Îl ridicăm puțin de jos
                }
                .navigationTitle("Hello, \(username)!")
                .sheet(isPresented: $showAddItemSheet) {
                    AddItemView()
                        .presentationDetents([.large])
                }
            }
        }
    
    // Vedere Empty State (Modernizată)
    var emptyStateView: some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.05), radius: 10)
                
                Image(systemName: "shield.slash.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.brandPrimary.opacity(0.4))
            }
            
            VStack(spacing: 8) {
                Text("No saved accounts")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text("Your data will be encrypted and stored here safely.")
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}
