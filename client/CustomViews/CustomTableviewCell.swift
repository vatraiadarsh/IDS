

import UIKit
// home screen
class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var column1Label: UILabel!
    @IBOutlet weak var column2Label: UILabel!
    @IBOutlet weak var column3Label: UILabel!
    @IBOutlet weak var column4Label: UILabel!

    static let identifier = "CustomTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
