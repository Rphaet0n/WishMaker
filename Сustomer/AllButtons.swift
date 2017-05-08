//
//  AllButtons.swift
//  WishMaker
//
//  Created by maxik on 09.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

@IBDesignable
class AllButtons: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
