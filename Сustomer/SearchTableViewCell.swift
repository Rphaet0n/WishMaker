//
//  SearchTableViewCell.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    var rootOrder : OrderModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
