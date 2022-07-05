

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func appliedFilters(protocols: [Constants.FilterProtocols], attackLevel: [Constants.FilterAttackLevels])
}

class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?

    @IBOutlet weak var attackICMPSwitch: UISwitch!
    @IBOutlet weak var attackTCPSwitch: UISwitch!
    @IBOutlet weak var attackUDPSwitch: UISwitch!

    @IBOutlet weak var attackLevelLowSwitch: UISwitch!
    @IBOutlet weak var attackLevelMediumSwitch: UISwitch!
    @IBOutlet weak var attackLevelHighSwitch: UISwitch!

    @IBOutlet weak var applyButton: UIButton!

    @IBOutlet weak var cardView: UIView!

    var selectedProtocolFilters: Set<Constants.FilterProtocols> = []
    var selectedAttackLevelFilters: Set<Constants.FilterAttackLevels> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    func setupUI() {
        cardView.layer.masksToBounds = false
        cardView.layer.cornerRadius = 20

        applyButton.layer.cornerRadius = 10.0
        applyButton.layer.masksToBounds = false

        updateFilters()
    }

    func updateFilters() {
        selectedProtocolFilters.forEach { obj in
            switch obj {
            case .ICMP:
                attackICMPSwitch.isOn = true
            case .TCP:
                attackTCPSwitch.isOn = true
            case .UDP:
                attackUDPSwitch.isOn = true
            }
        }

        selectedAttackLevelFilters.forEach { obj in
            switch obj {
            case .LOW:
                attackLevelLowSwitch.isOn = true
            case .MEDIUM:
                attackLevelMediumSwitch.isOn = true
            case .HIGH:
                attackLevelHighSwitch.isOn = true
            }
        }
    }

    @IBAction func applyFilter(_ sender: Any) {
        delegate?.appliedFilters(protocols: Array(selectedProtocolFilters), attackLevel: Array(selectedAttackLevelFilters))
        dismiss(animated: true, completion: nil)
    }

    @IBAction func switchValueChanged(_ sender: UISwitch) {

        if sender == attackUDPSwitch {
            if sender.isOn  { selectedProtocolFilters.insert(.UDP) } else  { selectedProtocolFilters.remove(.UDP) }
        } else if sender == attackTCPSwitch {
            if sender.isOn  { selectedProtocolFilters.insert(.TCP) } else  { selectedProtocolFilters.remove(.TCP) }
        } else if sender == attackICMPSwitch {
            if sender.isOn  { selectedProtocolFilters.insert(.ICMP) } else  { selectedProtocolFilters.remove(.ICMP) }
        }

        if sender == attackLevelLowSwitch {
            if sender.isOn  { selectedAttackLevelFilters.insert(.LOW) } else  { selectedAttackLevelFilters.remove(.LOW) }
        } else if sender == attackLevelMediumSwitch {
            if sender.isOn  { selectedAttackLevelFilters.insert(.MEDIUM) } else  { selectedAttackLevelFilters.remove(.MEDIUM) }
        } else if sender == attackLevelHighSwitch {
            if sender.isOn  { selectedAttackLevelFilters.insert(.HIGH) } else  { selectedAttackLevelFilters.remove(.HIGH) }
        }
    }
}
