import Foundation

struct Item: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String?
    var imageURL: String?
    var packaging: String?
    var isDiscontinued: Bool
    var categories: [Category]
    var tags: [Tag]
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case name = "item_name"
        case description
        case imageURL = "image_url"
        case packaging
        case isDiscontinued = "is_discontinued"
        case categories
        case tags
    }
} 