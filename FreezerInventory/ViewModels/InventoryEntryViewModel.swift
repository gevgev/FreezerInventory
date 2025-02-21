import Foundation

@MainActor
class InventoryEntryViewModel: ObservableObject {
    private let item: Item
    
    @Published var quantity = 1
    @Published var weight: Double = 0.0
    @Published var notes = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var isValid: Bool {
        quantity > 0 && weight > 0
    }
    
    init(item: Item) {
        self.item = item
    }
    
    func saveInventoryEntry() async {
        guard isValid else {
            errorMessage = "Please enter valid quantity and weight"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let entry = [
                "ItemID": item.id.uuidString,
                "Change": quantity,
                "Weight": weight,
                "WeightUnit": item.weightUnit ?? "kg",
                "Notes": notes
            ] as [String: Any]
            
            let entryData = try JSONSerialization.data(withJSONObject: entry)
            
            let _: EmptyResponse = try await APIClient.shared.request(
                endpoint: "/api/inventory",
                method: "POST",
                body: entryData
            )
            
            isLoading = false
            
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