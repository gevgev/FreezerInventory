import SwiftUI

struct MainTabView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @ObservedObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                TabView {
                    NavigationView {
                        InventoryListView(viewModel: InventoryListViewModel())
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Items", systemImage: "list.bullet")
                    }
                    
                    NavigationView {
                        InventoryStatusView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Current Stock", systemImage: "chart.bar.fill")
                    }
                    
                    NavigationView {
                        Text("Settings")
                            .navigationTitle("Settings")
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }
}

#Preview {
    MainTabView()
} 