import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
} 