import Foundation

struct Tag: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
} 