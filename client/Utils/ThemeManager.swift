
import Foundation
import UIKit

struct ThemeManager {
    static let shared = ThemeManager()

    enum Colors: String {
        case forestGreen = "#13872E"
        case lightGreen = "#9dcd50"
        case black = "#000000"
        case white = "#ffffff"
        case solitude = "#e6e9ed"
        case chocolate = "#D2691E"

        var color: UIColor {
            return .init(self.rawValue)
        }
    }
}


private extension UIColor {

    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
      var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if cString.hasPrefix("#") { cString.removeFirst() }

      if cString.count != 6 {
        self.init("ff0000") // return red color for wrong hex input
        return
      }

      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)

      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
    }

  }
