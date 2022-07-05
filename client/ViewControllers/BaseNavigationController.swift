

import Foundation
import Foundation
import UIKit
class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = ThemeManager.Colors.forestGreen.color
        navigationBar.backgroundColor = ThemeManager.Colors.forestGreen.color
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationBar.isTranslucent = true
    }
}
