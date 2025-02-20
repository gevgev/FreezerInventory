import Foundation
import Combine

class InventoryListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: Category?
    @Published var selectedTags: Set<Tag> = []
    
    func fetchInventory() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: [Item] = try await APIClient.shared.request(
                endpoint: "/inventory"
            )
            
            DispatchQueue.main.async {
                self.items = response
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func filteredItems() -> [Item] {
        var filtered = items
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.categories.contains(category) }
        }
        
        if !selectedTags.isEmpty {
            filtered = filtered.filter { item in
                !Set(item.tags).isDisjoint(with: selectedTags)
            }
        }
        
        return filtered
    }
} 