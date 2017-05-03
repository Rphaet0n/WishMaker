//
//  ViewController.swift
//  Сustomer
//
//  Created by maxik on 23.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let size = CGFloat(40)
    let xPosition = CGFloat(14)
    let options = UIViewAnimationOptions.autoreverse
    var blocks = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adding recognizer to the whole view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("screenTapped:"))
        view.addGestureRecognizer(tapRecognizer)
        blocks.append(createBlock())
    }
    
    //changed to return the created block so it can be stored in an array.
    func createBlock() -> UIImageView {
        let imageName = "block.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: xPosition, y: -40, width: size, height: size)
        self.view.addSubview(imageView)
        UIView.animate(withDuration: 2, delay: 0.0, options: options, animations: {
            imageView.backgroundColor = UIColor.red
            imageView.frame = CGRect(x: self.xPosition, y: 590, width: self.size, height: self.size)
            }, completion: { animationFinished in
                imageView.removeFromSuperview()
                self.blocks.append(self.createBlock())
        })
        return imageView
    }
    
    func screenTapped(gestureRecognizer: UITapGestureRecognizer) {
    }
    
}
