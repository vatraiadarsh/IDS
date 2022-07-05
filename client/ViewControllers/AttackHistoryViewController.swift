

import UIKit
import XYChart
import Alamofire
class AttackHistoryViewController: BaseViewController {
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerButton1: UIButton!
    @IBOutlet weak var datePickerButton2: UIButton!

    var chart: XYChart!
    var chartData: [XYChartDataSourceItem] = []

    var toDate: Date = Date()
    var fromDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()



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
    var graphDataSource: GraphModel? = nil {
        didSet {
            chart?.dataSource = self
            chart?.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        doSearch()
    }
    private func setupUI() {
        chart = XYChart.init(frame: chartView.bounds, chartType: .bar)
        chartView.addSubview(chart)
        chart.isUserInteractionEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        dataSource = nil

        datePickerButton1.layer.cornerRadius = 10.0
        datePickerButton1.layer.masksToBounds = false
        datePickerButton2.layer.cornerRadius = 10.0
        datePickerButton2.layer.masksToBounds = false

        updateFromDateTitle()
        updateToDateTitle()
        getGraphData()
    }

    func updateFromDateTitle() {
        let fromDateTitle = fromDate.getFormattedDate(format: "dd/MM/yy")
        datePickerButton1.setTitle(fromDateTitle, for: .normal)
    }

    func updateToDateTitle() {
        let toDateTitle = toDate.getFormattedDate(format: "dd/MM/yy")
        datePickerButton2.setTitle(toDateTitle, for: .normal)
    }


    @IBAction func didSelectDateRange(_ sender: UIButton) {
        if sender == datePickerButton1 {
            RPicker.selectDate(title: "Select from date", cancelText: "Cancel", datePickerMode: .date, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
                self?.fromDate = selectedDate
                self?.updateFromDateTitle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.doSearch()
                }
            })
        } else if sender == datePickerButton2 {
            RPicker.selectDate(title: "Select to date", cancelText: "Cancel", datePickerMode: .date, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
                self?.toDate = selectedDate
                self?.updateToDateTitle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.doSearch()
                }
            })
        }

    }

}
extension AttackHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.contentView.backgroundColor = indexPath.row % 2 != 0 ? ThemeManager.Colors.lightGreen.color : .white
        cell.column1Label.text = "\(dataSource?.data[indexPath.row].sourceIP ?? "")"
        cell.column2Label.text = "\(dataSource?.data[indexPath.row].destinationIP ?? "")"
        cell.column3Label.text = "\(dataSource?.data[indexPath.row].datumProtocol ?? "")"
        cell.column4Label.text = "\(dataSource?.data[indexPath.row].attackLevel ?? "")"

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



extension AttackHistoryViewController: XYChartDelegate, XYChartDataSource {
    func numberOfSections(in chart: XYChart) -> UInt {
        return 3
    }

    func numberOfRows(in chart: XYChart) -> UInt {
        let count = UInt(graphDataSource?.data.count ?? 0)
        print("[count  Abhi]: ", count)
        return count
    }

    func visibleRange(in chart: XYChart) -> XYRange {
        XYRangeMake(-5, 95)
    }

    func numberOfLevel(in chart: XYChart) -> UInt {
        return 5
    }

    func rowWidth(of chart: XYChart) -> CGFloat {
        return 0
    }

    func autoSizingRow(in chart: XYChart) -> Bool {
        true
    }

    func chart(_ chart: XYChart, titleOfRowAt index: UInt) -> NSAttributedString {
        NSAttributedString.init(string: graphDataSource?.data[Int(index)].date ?? "")
    }

    func chart(_ chart: XYChart, titleOfSectionAtValue sectionValue: CGFloat) -> NSAttributedString {
        print("[section]: ", "\(sectionValue)")

        return NSAttributedString.init(string: "\(Int(sectionValue + 5))")
    }

    func chart(_ chart: XYChart, itemOfIndex index: IndexPath) -> XYChartItemProtocol {
        let models = getchartModels()
        return models[index.row][index.section]
    }

    func  getchartModels() -> [[ChartModel]] {
        let highVal = graphDataSource!.data.map {$0.counts}.flatMap{$0}.map { $0.low ?? $0.medium ?? $0.high ?? 0}.sorted().last ?? 100
        print("[highVal]: ", highVal)
        let models = graphDataSource!.data.map({ graph -> [ChartModel]in


            var items = [ChartModel]()
            for obj in graph.counts {
                if let low = obj.low {
                    let model = ChartModel.init()
                    model.color = .black.withAlphaComponent(0.2)
                    let val = (Double(low)/Double(highVal)) * 100
                    print("[low]: ", low)
                    print("[val]: ", val)

                    model.value = NSNumber.init(value: val)
                    print("[model.value]: ", model.value)

                    model.duration = 0.6
                    items.append(model)
                }
                if let medium = obj.medium {
                    let model = ChartModel.init()
                    model.color = .black.withAlphaComponent(0.6)
                    let val = (medium/highVal) * 100
                    model.value = NSNumber.init(value: val)
                    model.duration = 0.6
                    items.append(model)
                }
                if let high = obj.high {
                    let model = ChartModel.init()
                    model.color = .black
                    let val = (high/highVal) * 100
                    model.value = NSNumber.init(value: val)
                    model.duration = 0.6
                    items.append(model)
                }
            }
            print("[items]: ", items.map{ $0.value})

            return items
        })


        return models

    }

}


class ChartModel: XYChartItem {

}


extension AttackHistoryViewController {

    func doSearch() {
        guard validateNetworkConnection() else { return }

        guard fromDate < toDate else {
            presentOKAlert(withTitle: "Error", message: "From date should be less than to date.", completion: nil)
            return
        }
        activityIndicatorBegin()

        let parameters = [
            "fromDate" : fromDate.getFormattedDate(format: "MM/dd"),
            "toDate" : toDate.getFormattedDate(format: "MM/dd"),
        ]

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

                        print("dataSource = ",self!.dataSource?.data.count)
//                        print("json = ",json)

                    } else {
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error", message: error.localizedDescription)
            }
        }

    }

}



extension AttackHistoryViewController {
    private func getGraphData() {
        AF.request(URL.init(string: Constants.API.graph)!, method: .get, encoding: JSONEncoding.default).responseJSON { [weak self](response) in
            self?.activityIndicatorEnd()
            switch response.result {
            case .success(_):
                if let json = response.value as? [String: Any] {
                    if let statusCode = response.response?.statusCode, statusCode == 200
                    {
                        let decoder = JSONDecoder()
                        self?.graphDataSource = try? decoder.decode(GraphModel.self, from: response.data!)
                    } else {
                    }
                }
            case .failure(let error):
                self?.presentOKAlert(withTitle: "Error loading graph data", message: error.localizedDescription)
            }
        }
    }
}
