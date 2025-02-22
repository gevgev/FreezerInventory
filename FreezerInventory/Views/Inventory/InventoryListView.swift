import SwiftUI

struct InventoryListView: View {
    @StateObject var viewModel: InventoryListViewModel
    @State private var showingFilters = false
    @State private var showingAddItem = false
    
    var body: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error, retryAction: {
                    Task {
                        await viewModel.fetchInventory()
                    }
                })
            } else {
                ForEach(viewModel.filteredItems()) { item in
                    InventoryItemRow(item: item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteItem(item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.fetchInventory()
        }
        .navigationTitle("Inventory")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddItem = true
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
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
        .task {
            await viewModel.fetchInventory()
        }
    }
}

struct InventoryItemRow: View {
    let item: Item
    @State private var showingInventoryEntry = false
    
    var body: some View {
        Button(action: {
            showingInventoryEntry = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                
                if let description = item.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let categories = item.categories, !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
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
        .sheet(isPresented: $showingInventoryEntry) {
            InventoryEntryView(item: item)
        }
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
    NavigationView {
        InventoryListView(viewModel: InventoryListViewModel())
    }
} 