//
//  TableCell.swift
//  MMS_UAS
//
//  Created by fandy on 14/02/21.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var cellPicture: UIImageView!
    
    @IBOutlet weak var cellWord: UILabel!
    
    @IBOutlet weak var cellType: UILabel!
    
    @IBOutlet weak var cellDefinition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
