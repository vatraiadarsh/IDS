

import UIKit
import Alamofire
class ManageAttackViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backupButton: UIButton!
    @IBOutlet weak var enableFirewallButton: UIButton!

    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var selectAllImage: UIImageView!

    var selectAllFlag = false
    var dataSource: SnortModel? = nil {
        didSet {
            activityIndicatorEnd()
            tableView.reloadData()
            if (dataSource?.data.isEmpty ?? false) || dataSource == nil {
                showNoDataMessage(onView: tableView)
            } else {
                hideNoDataMessage()
            }
        }
    }

    var backupJson: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {

        showNoDataMessage(onView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true

        dataSource = nil
        backupButton.layer.cornerRadius = 10.0
        backupButton.layer.masksToBounds = false

        enableFirewallButton.layer.cornerRadius = 10.0
        enableFirewallButton.layer.masksToBounds = false
    }

    @IBAction func enableFireWallAction(_ sender: Any) {
        enableFireWall()
    }

    @IBAction func backupInfoAction(_ sender: Any) {
        guard validateNetworkConnection() else { return }

        guard let email = UserDefaultsHelper.getData(type: String.self, forKey: .email), email.isValidEmail else {

            presentOKAlert(withTitle: "Error", message: "Invalid session. Please relogin") {
                UserDefaultsHelper.setData(value: false, key: .isLoggedIn)
                if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVCID") as! MainViewController

                    delegate.window?.rootViewController = newViewController
                    delegate.window?.makeKeyAndVisible()
                }
            }
            return
        }
        activityIndicatorBegin()

        let parameters = [
            "enable" : "1",
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        AF.request(URL.init(string: Constants.API.backupLogs)!, method: .post,parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            switch response.result {
            case .success(_):
                if let _ = response.value as? [String: Any] {
                    self?.activityIndicatorEnd()
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        self?.presentOKAlert(withTitle: "Backup success", message: "Server logs shared to email : \(email)")
                    } else {
                    }
                }
            case .failure(let error):
                self?.activityIndicatorEnd()
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        doSearch()
    }

    @IBAction func hideAction(_ sender: Any) {
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let selectedData = selectedIndexPaths?.map { dataSource?.data[$0.row].id ?? nil }.compactMap{ $0 }

        print("[hideAction Abhi]: ", selectedData?.count ?? -2 , selectedData)
        hideIDs(ids: selectedData)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let selectedData = selectedIndexPaths?.map { dataSource?.data[$0.row].id ?? nil }.compactMap{ $0 }

        print("[deleteAction Abhi]: ", selectedData?.count ?? -2 , selectedData)
        deleteIDs(ids: selectedData)
    }

    @IBAction func selectAllAction(_ sender: Any) {
        selectAllFlag = !selectAllFlag
        selectAllImage.image = selectAllFlag ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "checkmark.circle")!

        if selectAllFlag {
            let totalRows = tableView.numberOfRows(inSection: 0)
            for row in 0..<totalRows {
                let indexPath = IndexPath(row: row, section: 0)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                let cell = tableView.cellForRow(at: indexPath) as? ManageAttackCell
                cell?.checkIconImage.image = UIImage(systemName: "checkmark.circle.fill")!
            }
        } else {
            let totalRows = tableView.numberOfRows(inSection: 0)
            for row in 0..<totalRows {
                let indexPath = IndexPath(row: row, section: 0)
                tableView.deselectRow(at: indexPath, animated: false)
                let cell = tableView.cellForRow(at: indexPath) as? ManageAttackCell
                cell?.checkIconImage.image = UIImage(systemName: "checkmark.circle")!
            }
        }
    }
}


extension ManageAttackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ManageAttackCell.identifier, for: indexPath) as! ManageAttackCell
        cell.contentView.backgroundColor = indexPath.row % 2 != 0 ? ThemeManager.Colors.lightGreen.color : .white
        cell.column1Label.text = "\(dataSource?.data[indexPath.row].alertName ?? "")"
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        cell.checkIconImage.image = rowIsSelected ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "checkmark.circle")!

        cell.invisibleButton?.removeFromSuperview()
        return cell
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as?  ManageAttackCell
         cell?.checkIconImage.image = UIImage(systemName: "checkmark.circle.fill")!
    }

     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)  as?  ManageAttackCell
         cell?.checkIconImage.image = UIImage(systemName: "checkmark.circle")!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}


extension ManageAttackViewController {
    func doSearch() {
        guard validateNetworkConnection() else { return }
        activityIndicatorBegin()


        AF.request(Constants.API.searchSnortLogs, method: .get, encoding: URLEncoding.default).responseJSON { [weak self](response) in
            self?.activityIndicatorEnd()
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        let decoder = JSONDecoder()
                        self?.dataSource = try? decoder.decode(SnortModel.self, from: response.data!)
                        self?.backupJson = String(decoding: response.data!, as: UTF8.self)
                    } else {
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }

    }

//    func backupInfo() {
//        createReadAndWriteFile()
//    }
//
//
//     func createReadAndWriteFile() {
//         let fileName = "attackData" + Date().getFormattedDate(format: "dd-MM-yyyy_hh:mm")
//        let documentDirectoryUrl = try! FileManager.default.url(
//            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
//        )
//        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName).appendingPathExtension("txt")
//        // prints the file path
//        print("File path \(fileUrl.path)")
//        //data to write in file.
//        let stringData = backupJson ?? ""
//        do {
//            try stringData.write(to: fileUrl, atomically: true, encoding: String.Encoding.utf8)
//            let url = NSURL.fileURL(withPath: fileUrl.absoluteString)
//
//            let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)
//
//            DispatchQueue.main.async {
//                self.present(activityViewController, animated: true, completion: nil)
//            }
//        } catch let error as NSError {
//            print (error)
//        }
//        var readFile = ""
//        do {
//            readFile = try String(contentsOf: fileUrl)
//        } catch let error as NSError {
//            print(error)
//        }
//        print (readFile)
//    }

    func deleteIDs(ids: [String]!) {
        guard validateNetworkConnection() else { return }
        activityIndicatorBegin()
        let parameters = [
            "id" : ids
        ]
        AF.request(Constants.API.deleteLogs, method: .delete, parameters: parameters as Parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        self?.showToast(message: "Delete successful")
                        self?.doSearch()
                    } else {
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.activityIndicatorEnd()
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }

    }

    func hideIDs(ids: [String]?) {
        guard validateNetworkConnection() else { return }
        activityIndicatorBegin()
        let parameters = [
            "id" : ids
        ]
        AF.request(Constants.API.hideLogs, method: .put, parameters: parameters as Parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        self?.showToast(message: "Hide successful")
                        self?.doSearch()
                    } else {
                        self?.activityIndicatorEnd()
                    }
                }
            case .failure(let error):
                self?.activityIndicatorEnd()
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }

    func enableFireWall() {
        guard validateNetworkConnection() else { return }
        activityIndicatorBegin()
        let parameters = [
            "enable" : "0"
        ]
        AF.request(Constants.API.enableFirewall, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    self?.activityIndicatorEnd()
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        self?.showToast(message: "Firewall enabled on network")
                    } else {
                    }
                }
            case .failure(let error):
                self?.activityIndicatorEnd()
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }
    }
}



