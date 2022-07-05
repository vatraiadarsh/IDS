
import Foundation
import UIKit
class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var menuButton: UIBarButtonItem!

    var homeViewController: HomeViewController!
    var manageAttackViewController: ManageAttackViewController!
    var monitorAttackViewController: MonitorAttackViewController!
    var attackHistoryViewController: AttackHistoryViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        navigationController?.navigationBar.barTintColor = ThemeManager.Colors.forestGreen.color
        navigationController?.navigationBar.backgroundColor = ThemeManager.Colors.forestGreen.color
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.isTranslucent = false

        menuButton = UIBarButtonItem.init(image:UIImage.init(named: "menu-1"), style: .plain, target: revealViewController(), action: #selector(revealViewController()?.revealSideMenu))
        navigationItem.leftBarButtonItem =  menuButton


        let profileButton = UIBarButtonItem.init(image:UIImage.init(named: "user"), style: .plain, target: self, action: #selector(openProfile))
        navigationItem.rightBarButtonItem =  profileButton

        setUpVCs()
    }

    @objc func openProfile() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileVCID") as! ProfileViewController
        profileVC.isPushed = true
        navigationController?.pushViewController(profileVC, animated: true)
    }

    private func setUpVCs() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeVCID") as? HomeViewController

        addChild(homeViewController)
        containerView.addSubview(homeViewController.view)
        homeViewController.didMove(toParent: self)
        homeViewController.view.frame = containerView.bounds

        monitorAttackViewController = storyBoard.instantiateViewController(withIdentifier: "MonitorAttackViewControllerID") as? MonitorAttackViewController

        addChild(monitorAttackViewController)
        containerView.addSubview(monitorAttackViewController.view)
        monitorAttackViewController.didMove(toParent: self)
        monitorAttackViewController.view.frame = containerView.bounds

        manageAttackViewController = storyBoard.instantiateViewController(withIdentifier: "ManageAttackViewControllerID") as? ManageAttackViewController

        addChild(manageAttackViewController)
        containerView.addSubview(manageAttackViewController.view)
        manageAttackViewController.didMove(toParent: self)
        manageAttackViewController.view.frame = containerView.bounds

        attackHistoryViewController = storyBoard.instantiateViewController(withIdentifier: "AttackHistoryViewControllerID") as? AttackHistoryViewController

        addChild(attackHistoryViewController)
        containerView.addSubview(attackHistoryViewController.view)
        attackHistoryViewController.didMove(toParent: self)
        attackHistoryViewController.view.frame = containerView.bounds

        hideAllVCs()
        homeViewController.view.isHidden = false
        self.navigationItem.title = "Home"
    }

    @objc func menuTapped() {
        revealViewController()?.revealSideMenu()
    }

    private func hideAllVCs() {
        homeViewController.view.isHidden = true
        monitorAttackViewController.view.isHidden = true
        manageAttackViewController.view.isHidden = true
        attackHistoryViewController.view.isHidden = true
    }


    @IBAction func homeButtonAction() {
        hideAllVCs()
        homeViewController.view.isHidden = false
        self.navigationItem.title = "Home"
    }
    @IBAction func monitorAttackButtonAction() {
        hideAllVCs()
        monitorAttackViewController.view.isHidden = false
        self.navigationItem.title = "Monitor Attacks"
    }
    @IBAction func manageAttackButtonAction() {
        hideAllVCs()
        manageAttackViewController.view.isHidden = false
        self.navigationItem.title = "Manage Attack"
    }
    @IBAction func attackHistoryButtonAction() {
        hideAllVCs()
        attackHistoryViewController.view.isHidden = false
        self.navigationItem.title = "Attack History"
    }
}
