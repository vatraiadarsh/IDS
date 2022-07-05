

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        navigationItem.title = "Settings"
        menuButton = UIBarButtonItem.init(image:UIImage.init(named: "menu-1"), style: .plain, target: revealViewController(), action: #selector(revealViewController()?.revealSideMenu))
        navigationItem.leftBarButtonItem =  menuButton

        appNameLabel.text = Bundle.main.displayName
        versionLabel.text = "v" + Bundle.main.appVersionLong
    }
}
