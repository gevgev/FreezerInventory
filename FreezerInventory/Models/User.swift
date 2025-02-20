import Foundation

struct User: Codable {
    let id: UUID
    var email: String
    var role: UserRole
    
    enum UserRole: String, Codable {
        case admin
        case user
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case role
    }
} 