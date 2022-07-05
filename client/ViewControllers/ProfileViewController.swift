
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var menuButton: UIBarButtonItem!

    var isPushed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        navigationItem.title = "User Info"
        userNameLabel.text = UserDefaultsHelper.getData(type: String.self, forKey: .username)
        emailLabel.text = UserDefaultsHelper.getData(type: String.self, forKey: .email)

        if !isPushed {
        menuButton = UIBarButtonItem.init(image:UIImage.init(named: "menu-1"), style: .plain, target: revealViewController(), action: #selector(revealViewController()?.revealSideMenu))
        navigationItem.leftBarButtonItem =  menuButton
        }
    }
}
