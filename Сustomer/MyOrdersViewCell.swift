//
//  TableViewCell.swift
//  WishMaker
//
//  Created by maxik on 07.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class MyOrdersViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checking: AllButtons!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
