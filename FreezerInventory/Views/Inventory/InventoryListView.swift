import SwiftUI

struct InventoryListView: View {
    @StateObject var viewModel: InventoryListViewModel
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error, retryAction: {
                        Task {
                            await viewModel.fetchInventory()
                        }
                    })
                } else {
                    List(viewModel.filteredItems()) { item in
                        InventoryItemRow(item: item)
                    }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add new item action
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingFilters = true
                    }) {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            if viewModel.selectedCategory != nil || !viewModel.selectedTags.isEmpty {
                                Text("\(viewModel.selectedTags.count + (viewModel.selectedCategory != nil ? 1 : 0))")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    filterViewModel: FilterViewModel(),
                    inventoryViewModel: viewModel
                )
            }
        }
        .task {
            await viewModel.fetchInventory()
        }
    }
}

struct InventoryItemRow: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name)
                .font(.headline)
            
            if let description = item.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let categories = item.categories, !categories.isEmpty {
                HStack {
                    ForEach(categories) { category in
                        Text(category.name)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            
            HStack {
                if let packaging = item.packaging {
                    Text(packaging)
                        .font(.caption)
                }
                if let weightUnit = item.weightUnit {
                    Text("(\(weightUnit))")
                        .font(.caption)
                }
            }
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .foregroundColor(.red)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
    }
}

#Preview {
    InventoryListView(viewModel: InventoryListViewModel())
} 