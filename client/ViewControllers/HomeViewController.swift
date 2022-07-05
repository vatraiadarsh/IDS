
import Foundation
import UIKit
import Alamofire
class HomeViewController: BaseViewController {

    @IBOutlet weak var scanButton: PulseButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var attackNumLabel: UILabel!
    @IBOutlet weak var attackPercentLabel: UILabel!

    var dataSource: SnortModel? = nil {
        didSet {
            activityIndicatorEnd()
            tableView.reloadData()
            if dataSource?.data.isEmpty ?? false {
                showNoDataMessage(onView: tableView)
            } else {
                hideNoDataMessage()
            }
            attackNumLabel.text = "\(dataSource?.attackCount ?? 0)"
            attackPercentLabel.text = dataSource?.attackPercentage ?? "0%"
        }
    }
    var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        showNoDataMessage(onView: tableView)

        scanButton.font = UIFont(name: "TimesNewRomanPSMT", size: 32.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        attackNumLabel.text = "0"
        attackPercentLabel.text = "0%"
    }

    @objc func menuTapped() {
        revealViewController()?.revealSideMenu()
    }

    @IBAction func scanButtonAction() {
        guard validateNetworkConnection() else { return }
        activityIndicatorBegin()
        getSnortData()
        scanButton.animate(start: true)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.contentView.backgroundColor = indexPath.row % 2 != 0 ? ThemeManager.Colors.lightGreen.color : .white
        cell.column1Label.text = "\(dataSource?.data[indexPath.row].alertName ?? "")"
        cell.column2Label.text = "\(dataSource?.data[indexPath.row].actualDatetime ?? "")"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = dataSource?.data[indexPath.row].alertName ?? "Attack"
        let model = dataSource?.data[indexPath.row]
        let dict = try! DictionaryEncoder.encode(model)
        var descString = ""
        for (key, val) in dict {
            descString += key + ":" + "\(val)" + "\n"
        }
        presentOKAlert(withTitle: title, message: descString)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


extension HomeViewController {
    private func getSnortData() {
        AF.request(URL.init(string: Constants.API.searchSnortLogs)!, method: .get, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            self?.activityIndicatorEnd()
            switch response.result {
            case .success(_):
                self?.scanButton.animate(start: false)
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        let decoder = JSONDecoder()
                        self?.dataSource = try? decoder.decode(SnortModel.self, from: response.data!)
                    } else {
                    }
                }
            case .failure(let error):
                self?.scanButton.animate(start: false)
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }
}

struct DictionaryEncoder {
    static func encode<T>(_ value: T) throws -> [String: Any] where T: Encodable {
        let jsonData = try JSONEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    }
}
