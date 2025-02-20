import Foundation
import Combine

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
            async let categoriesResponse: [Category] = APIClient.shared.request(endpoint: "/categories")
            async let tagsResponse: [Tag] = APIClient.shared.request(endpoint: "/tags")
            
            let (fetchedCategories, fetchedTags) = try await (categoriesResponse, tagsResponse)
            
            DispatchQueue.main.async {
                self.allCategories = fetchedCategories
                self.allTags = fetchedTags
                self.categories = fetchedCategories
                self.tags = fetchedTags
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
} 