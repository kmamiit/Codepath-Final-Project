//
//  EBTableViewCell.swift
//  countCards
//
//  Created by Kyle Mamiit (New) on 12/21/18.
//  Copyright © 2018 Kyle Mamiit. All rights reserved.
//

import UIKit

class EBTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
