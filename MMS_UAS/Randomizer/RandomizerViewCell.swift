//
//  RandomizerViewCell.swift
//  MMS_UAS
//
//  Created by fandy on 15/02/21.
//

import UIKit

class RandomizerViewCell: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    
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
