import Foundation

struct Tag: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
    }
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
} 