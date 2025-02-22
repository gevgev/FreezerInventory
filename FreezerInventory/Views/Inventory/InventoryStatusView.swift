import SwiftUI

struct InventoryStatusView: View {
    @StateObject private var viewModel = InventoryStatusViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error, retryAction: {
                    Task {
                        await viewModel.fetchInventoryStatus()
                    }
                })
            } else {
                List {
                    ForEach(viewModel.inventory) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.itemName)
                                .font(.headline)
                            
                            HStack {
                                Label("\(item.quantity)", systemImage: "number")
                                Spacer()
                                Label("\(String(format: "%.1f", item.weight)) \(item.weightUnit)", systemImage: "scalemass")
                            }
                            .foregroundColor(.secondary)
                            
                            Text("Last updated: \(formatDate(item.lastUpdated))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .refreshable {
                    await viewModel.fetchInventoryStatus()
                }
            }
        }
        .navigationTitle("Current Inventory")
        .task {
            await viewModel.fetchInventoryStatus()
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            return dateString
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        InventoryStatusView()
    }
} 