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
    
    var delegate: MyOrderTableViewController!
    var ind: Int!
    
    @IBAction func completeOrder(_ sender: Any) {
        self.checking.isHidden = self.delegate.completeOrder(ind)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
