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
            handleError(error)
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    func deleteItem(_ item: Item) async {
        do {
            let _: EmptyResponse = try await APIClient.shared.request(
                endpoint: "/api/items/\(item.id)",
                method: "DELETE"
            )
            
            // Remove item from local array
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items.remove(at: index)
            }
            
        } catch let error as APIError {
            handleError(error)
        } catch {
            errorMessage = error.localizedDescription
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
    
    private func handleError(_ error: APIError) {
        switch error {
        case .unauthorized:
            errorMessage = "Please log in again"
        case .serverError(let message):
            errorMessage = message
        case .decodingError:
            errorMessage = "Failed to process server response"
        default:
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct EmptyResponse: Codable {} 