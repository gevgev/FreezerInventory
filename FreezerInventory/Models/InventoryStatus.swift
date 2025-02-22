import Foundation

struct InventoryStatus: Codable, Identifiable {
    let itemId: UUID
    let itemName: String
    let quantity: Int
    let lastUpdated: String
    let weight: Double
    let weightUnit: String
    
    var id: UUID { itemId }
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case itemName = "item_name"
        case quantity
        case lastUpdated = "last_updated"
        case weight
        case weightUnit = "weight_unit"
    }
} 