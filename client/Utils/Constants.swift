

import Foundation

struct Constants {
    struct API {
        static let signup = "http://localhost:8080/api/auth/signup"
        static let signin = "http://localhost:8080/api/auth/signin"
        static let signout = "http://localhost:8080/api/auth/signout"
        static let forgotPassword = "http://localhost:8080/api/auth/forget-password"
        static let validateOTP = "http://localhost:8080/api/auth/validate-forget-password"
        static let searchSnortLogs = "http://localhost:8080/api/alert/search-snort-logs"
        static let hideLogs = "http://localhost:8080/api/alert/hide-snort-logs"
        static let deleteLogs = "http://localhost:8080/api/alert/delete-snort-logs"
        static let notification = "http://localhost:8080/api/cron/get-notification"
        static let backupLogs = "http://localhost:8080/api/alert/backup-snort-logs"
        static let graph = "http://localhost:8080/api/alert/get-graph-data"
        static let enableFirewall = "http://localhost:8080/api/alert/enable-Firewall"
    }

    enum UserDefaultKeys: String {
        case email
        case username
        case password
        case id
        case isLoggedIn
    }

    enum FilterProtocols: String {
        case ICMP, TCP, UDP
    }

    enum FilterAttackLevels: String {
        case LOW = "Low"
        case MEDIUM = "Medium"
        case HIGH = "High"
    }
}
