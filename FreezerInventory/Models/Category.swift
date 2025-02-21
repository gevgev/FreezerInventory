import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case description = "Description"
    }
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
} 