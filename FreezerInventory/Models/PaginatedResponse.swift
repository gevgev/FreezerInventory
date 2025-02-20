import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let data: [T]
    let pagination: Pagination
    
    struct Pagination: Codable {
        let total: Int
        let page: Int
        let per_page: Int
    }
} 