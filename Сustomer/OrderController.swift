//
//  OrderController.swift
//  WishMaker
//
//  Created by maxik on 06.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class OrderController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var array = ["1","2","3"]
    
    func addNew(item: Item){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    

}
