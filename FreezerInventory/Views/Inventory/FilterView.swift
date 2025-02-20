import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var filterViewModel: FilterViewModel
    @ObservedObject var inventoryViewModel: InventoryListViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Search categories and tags", text: $filterViewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section("Categories") {
                    if filterViewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(filterViewModel.filteredCategories) { category in
                            FilterRowView(
                                title: category.name,
                                isSelected: inventoryViewModel.selectedCategory?.id == category.id
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    if inventoryViewModel.selectedCategory?.id == category.id {
                                        inventoryViewModel.selectedCategory = nil
                                    } else {
                                        inventoryViewModel.selectedCategory = category
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Tags") {
                    if filterViewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(filterViewModel.filteredTags) { tag in
                            FilterRowView(
                                title: tag.name,
                                isSelected: inventoryViewModel.selectedTags.contains(tag)
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    if inventoryViewModel.selectedTags.contains(tag) {
                                        inventoryViewModel.selectedTags.remove(tag)
                                    } else {
                                        inventoryViewModel.selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        withAnimation(.spring(response: 0.3)) {
                            inventoryViewModel.selectedCategory = nil
                            inventoryViewModel.selectedTags.removeAll()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await filterViewModel.fetchFilters()
        }
    }
}

struct FilterRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

#Preview {
    FilterView(
        filterViewModel: FilterViewModel(),
        inventoryViewModel: InventoryListViewModel()
    )
} 