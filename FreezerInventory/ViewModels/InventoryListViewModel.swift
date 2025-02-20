import Foundation
import Combine

@MainActor
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
            let items: [Item] = try await APIClient.shared.request(
                endpoint: "/api/items"
            )
            
            self.items = items
            self.isLoading = false
            
        } catch let error as APIError {
            switch error {
            case .decodingError:
                errorMessage = "Failed to load inventory data"
            case .serverError(let message):
                errorMessage = message
            default:
                errorMessage = error.localizedDescription
            }
            self.isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
    
    func filteredItems() -> [Item] {
        var filtered = items
        
        if let category = selectedCategory {
            filtered = filtered.filter { item in
                guard let categories = item.categories else { return false }
                return categories.contains(category)
            }
        }
        
        if !selectedTags.isEmpty {
            filtered = filtered.filter { item in
                guard let tags = item.tags else { return false }
                return !Set(tags).isDisjoint(with: selectedTags)
            }
        }
        
        return filtered
    }
} 