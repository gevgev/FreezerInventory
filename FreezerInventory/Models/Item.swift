import Foundation

struct Item: Codable, Identifiable {
    let id: UUID
    var name: String
    var description: String?
    var barcode: String?
    var imageURL: String?
    var packaging: String?
    var weightUnit: String?
    var expirationDate: String?
    var createdAt: String
    var updatedAt: String
    var deletedAt: String?
    var categories: [Category]?
    var tags: [Tag]?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case description = "Description"
        case barcode = "Barcode"
        case imageURL = "ImageURL"
        case packaging = "Packaging"
        case weightUnit = "WeightUnit"
        case expirationDate = "ExpirationDate"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
        case categories = "Categories"
        case tags = "Tags"
    }
} 