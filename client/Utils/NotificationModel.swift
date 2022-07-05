

import Foundation

// MARK: - NotificationModel
struct NotificationModel: Codable {
    let notification: [NotificationViewModel]
}

// MARK: - Notification
struct NotificationViewModel: Codable {
    let id, alertName, alertID, actualDatetime: String
    let priority, notificationSentDatetime, notificationMessage: String?
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case alertName
        case alertID = "alertId"
        case actualDatetime, priority, notificationSentDatetime, notificationMessage
        case v = "__v"
    }
}
