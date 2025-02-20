import Foundation
import Combine

@MainActor
class FilterViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var tags: [Tag] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var allCategories: [Category] = []
    private var allTags: [Tag] = []
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return allCategories
        }
        return allCategories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredTags: [Tag] {
        if searchText.isEmpty {
            return allTags
        }
        return allTags.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    func fetchFilters() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let categoriesResponse: [Category] = APIClient.shared.request(endpoint: "/api/categories")
            async let tagsResponse: [Tag] = APIClient.shared.request(endpoint: "/api/tags")
            
            let (fetchedCategories, fetchedTags) = try await (categoriesResponse, tagsResponse)
            
            self.categories = fetchedCategories
            self.tags = fetchedTags
            self.isLoading = false
            
        } catch let error as APIError {
            switch error {
            case .decodingError:
                errorMessage = "Failed to load filters"
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
} 