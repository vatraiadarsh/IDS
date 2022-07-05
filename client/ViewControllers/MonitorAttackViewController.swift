
import UIKit
import Alamofire
class MonitorAttackViewController: BaseViewController, FilterViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!

    @IBOutlet weak var searchBar: UISearchBar!


    var selectedProtocolFilters: [Constants.FilterProtocols] = []
    var selectedAttackLevelFilters: [Constants.FilterAttackLevels] = []
    var dataSource: SnortModel? = nil {
        didSet {
            activityIndicatorEnd()
            tableView.reloadData()
            if dataSource?.data.isEmpty ?? false {
                showNoDataMessage(onView: tableView)
            } else {
                hideNoDataMessage()
            }
        }
    }

    enum SortOptions: String {
        case dateSort = "dateSort"
        case attackLevelSort = "attacklevelSort"
        case alertNamesort = "alertNamesort"

        func description() -> String {
            switch self {
            case .dateSort: return "Date"
            case .alertNamesort: return "Name"
            case .attackLevelSort: return "Attack Level"
            }
        }
    }

    var selectedSortOption = SortOptions.attackLevelSort
    var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {

        showNoDataMessage(onView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        updateSortButton()
        doSearch()
    }

    func updateSortButton() {
        sortButton.setTitle(selectedSortOption.description() + " ▼", for: .normal)
        sortButton.layer.cornerRadius = 10.0
        sortButton.layer.masksToBounds = false


        filterButton.layer.cornerRadius = 10.0
        filterButton.layer.masksToBounds = false
    }

    func showFilter() {
        guard let filterVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "filterVC") as? FilterViewController else {
            return
        }
        filterVC.delegate = self
        filterVC.view.backgroundColor = .black.withAlphaComponent(0.75)
        filterVC.modalPresentationStyle = .overCurrentContext
        filterVC.selectedProtocolFilters = Set(selectedProtocolFilters)
        filterVC.selectedAttackLevelFilters = Set(selectedAttackLevelFilters)
        present(filterVC, animated: false) {
            filterVC.updateFilters()
        }
    }

    @IBAction func displayFilter(_ sender: Any) {
        showFilter()
    }
    @IBAction func displayActionSheet(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose sort option", preferredStyle: .actionSheet)

        // 2
        let dateTitle = selectedSortOption == .dateSort ? SortOptions.dateSort.description() + " ◂" : SortOptions.dateSort.description()
        let sortDateAction = UIAlertAction(title: dateTitle, style: .default) { _ in
            self.selectedSortOption = .dateSort
            self.updateSortButton()
            self.doSearch()
        }

        let nameTitle = selectedSortOption == .alertNamesort ? SortOptions.alertNamesort.description() + " ◂" : SortOptions.alertNamesort.description()

        let sortAlertNameDateAction = UIAlertAction(title: nameTitle, style: .default) { _ in
            self.selectedSortOption = .alertNamesort
            self.updateSortButton()
            self.doSearch()
        }

        let attackLevelTitle = selectedSortOption == .attackLevelSort ? SortOptions.attackLevelSort.description() + " ◂" : SortOptions.attackLevelSort.description()

        let sortAttackLevelAction = UIAlertAction(title: attackLevelTitle, style: .default) { _ in
            self.selectedSortOption = .attackLevelSort
            self.updateSortButton()
            self.doSearch()
        }

        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // 4
        optionMenu.addAction(sortDateAction)
        optionMenu.addAction(sortAlertNameDateAction)
        optionMenu.addAction(sortAttackLevelAction)

        optionMenu.addAction(cancelAction)

        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}


extension MonitorAttackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.contentView.backgroundColor = indexPath.row % 2 != 0 ? ThemeManager.Colors.lightGreen.color : .white
        cell.column1Label.text = "\(indexPath.row + 1)"
        cell.column2Label.text = "\(dataSource?.data[indexPath.row].alertName ?? "")"

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


extension MonitorAttackViewController {
    func appliedFilters(protocols: [Constants.FilterProtocols], attackLevel: [Constants.FilterAttackLevels]) {
        selectedProtocolFilters = protocols
        selectedAttackLevelFilters = attackLevel
        self.doSearch()
    }
}


extension MonitorAttackViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }

    func doSearch() {
        guard validateNetworkConnection() else { return }
//        guard let text = searchBar.text, !text.isEmpty else {
//            presentOKAlert(withTitle: "Error", message: "Please enter search keyword", completion: nil)
//            return
//        }
        searchBar.resignFirstResponder()
        activityIndicatorBegin()
        var parameters: [String: Any] = [:]

        if let text = searchBar.text, !text.isEmpty {
            parameters = [
               "name" : text,
           ]
        }

        parameters[selectedSortOption.rawValue] = "1"

        if !selectedProtocolFilters.isEmpty {
            parameters["protocolFilters"] = selectedProtocolFilters.map{ $0.rawValue }.joined(separator: ",")
        }
        if !selectedAttackLevelFilters.isEmpty {
            parameters["levelFilters"] = selectedAttackLevelFilters.map{ $0.rawValue }.joined(separator: ",")
        }

        print("params = ",parameters)
        AF.request(Constants.API.searchSnortLogs, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { [weak self](response) in
            self?.activityIndicatorEnd()
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        let decoder = JSONDecoder()
                        self?.dataSource = try? decoder.decode(SnortModel.self, from: response.data!)

                    } else {
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }

    }

}
