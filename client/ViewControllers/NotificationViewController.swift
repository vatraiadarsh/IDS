
import Foundation
import UIKit
import Alamofire
class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: NotificationModel? = nil {
        didSet {
            tableView.reloadData()
            if (dataSource?.notification.isEmpty ?? false) || dataSource == nil {
                showNoDataMessage(onView: tableView)
            } else {
                hideNoDataMessage()
            }
            activityIndicatorEnd()
        }
    }

    let barColors: [UIColor] = [.red, .green, .yellow , .blue, .cyan]
    var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()

    }

    private func setupUI() {
        navigationItem.title = "Notifications"
        menuButton = UIBarButtonItem.init(image:UIImage.init(named: "menu-1"), style: .plain, target: revealViewController(), action: #selector(revealViewController()?.revealSideMenu))
        navigationItem.leftBarButtonItem =  menuButton

        tableView.delegate = self
        tableView.dataSource = self
        dataSource = nil
        activityIndicatorBegin()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        getNotificationData()
    }
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.notification.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.identifier, for: indexPath) as! NotificationTableViewCell
        cell.contentView.backgroundColor = .white
        let model = dataSource?.notification.reversed()[indexPath.row]
        cell.titlelabel.text = model?.alertName
        cell.dateLabel.text = "Date: " + ((model?.actualDatetime) ?? "")
        cell.dateLabel.textAlignment = .right
        cell.descriptionLabel.text = model?.notificationMessage ?? "Attack detected ⚠️"
        cell.barView.backgroundColor = ThemeManager.Colors.forestGreen.color
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.cornerRadius = 5
        cell.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.cardView.layer.shadowRadius = 10.0
        cell.cardView.layer.shadowOpacity = 0.5
        cell.cardView.layer.shadowColor = UIColor.gray.cgColor

        cell.barView.layer.masksToBounds = false
        cell.barView.layer.cornerRadius = 2

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}



extension NotificationViewController {
    private func getNotificationData() {
        AF.request(URL.init(string: Constants.API.notification)!, method: .get, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        let decoder = JSONDecoder()
                        self?.dataSource = try? decoder.decode(NotificationModel.self, from: response.data!)
                    } else {
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }
}
