import Foundation

@MainActor
class AddItemViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var barcode = ""
    @Published var packaging = ""
    @Published var weightUnit = "kg"
    @Published var expirationDate = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var isValid: Bool {
        !name.isEmpty && !weightUnit.isEmpty
    }
    
    func saveItem() async {
        guard isValid else {
            errorMessage = "Please fill in all required fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let item = [
                "Name": name,
                "Description": description,
                "Barcode": barcode,
                "Packaging": packaging,
                "WeightUnit": weightUnit,
                "ExpirationDate": ISO8601DateFormatter().string(from: expirationDate)
            ]
            
            let itemData = try JSONSerialization.data(withJSONObject: item)
            
            let _: Item = try await APIClient.shared.request(
                endpoint: "/api/items",
                method: "POST",
                body: itemData
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