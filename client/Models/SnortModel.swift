

import Foundation

// MARK: - SnortModel
struct SnortModel: Codable {
    let attackCount: Int
    let attackPercentage: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: String
    let alertName: String
    let actualDatetime, priority, sourceIP: String
    let destinationIP: String
    let datumProtocol: String
    let attackLevel: String
    let isHidden: Bool
    let alertDescription: String
    let datetime: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case alertName, actualDatetime, priority, sourceIP, destinationIP
        case datumProtocol = "protocol"
        case attackLevel, isHidden, alertDescription, datetime
        case v = "__v"
    }
}
