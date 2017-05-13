//
//  LaunchViewController.swift
//  WishMaker
//
//  Created by maxik on 11.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 2.0,target:self,selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)

        // Do any additional setup after loading the view.
    }
    
    func timeToMoveOn() {
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
