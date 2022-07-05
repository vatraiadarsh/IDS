

import Foundation
import UIKit

class ManageAttackCell: UITableViewCell {

    @IBOutlet weak var column1Label: UILabel!
    @IBOutlet weak var checkIconImage: UIImageView!
    @IBOutlet weak var invisibleButton: UIButton!


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
