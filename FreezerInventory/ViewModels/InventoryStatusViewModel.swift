import Foundation

@MainActor
class InventoryStatusViewModel: ObservableObject {
    @Published var inventory: [InventoryStatus] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchInventoryStatus() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: InventoryResponse = try await APIClient.shared.request(
                endpoint: "/api/inventory"
            )
            
            self.inventory = response.inventory
            self.isLoading = false
            
        } catch let error as APIError {
            handleError(error)
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
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