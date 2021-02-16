//
//  BookmarkTableViewCell.swift
//  MMS_UAS
//
//  Created by fandy on 16/02/21.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

    @IBOutlet weak var bookmarkImage: UIImageView!
    
    @IBOutlet weak var bookmarkType: UILabel!
    
    @IBOutlet weak var bookmarkDefinition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
