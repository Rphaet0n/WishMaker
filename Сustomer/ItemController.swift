//
//  ItemController.swift
//  WishMaker
//
//  Created by maxik on 01.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class ItemController: UIViewController {

    @IBOutlet weak var Iname: UITextField!
    @IBOutlet weak var Icount: UITextField!
    @IBOutlet weak var IDestination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addButton(_ sender: UIButton) {
        var it = Item(Iname: Iname.text!, Icount: Int(Icount.text!)!, Iaddress: IDestination.text!, Iprice: 100)
        
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
