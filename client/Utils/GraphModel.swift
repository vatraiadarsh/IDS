
import Foundation

// MARK: - GraphModel
struct GraphModel: Codable {
    let data: [Graph]
}

// MARK: - Graph
struct Graph: Codable {
    let date: String
    let counts: [Count]
}

// MARK: - Count
struct Count: Codable {
    let low, medium, high, highest: Int?

    enum CodingKeys: String, CodingKey {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case highest = "Highest"
    }
}
