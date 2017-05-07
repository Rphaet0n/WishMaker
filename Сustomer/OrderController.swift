//
//  OrderController.swift
//  WishMaker
//
//  Created by maxik on 06.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class OrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myOrders: UITableView!
    var orders: Array<Order> = []
    
    // For Ardashes
    func loadMyOrders () -> Array<Order> {
        var myOrdersArray = Array<Order>()
        
        return myOrdersArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orders = loadMyOrders()
        self.myOrders.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myOrders.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyOrdersViewCell
        
        cell.itemname.text = self.orders[indexPath.row].item.title
        cell.checking.isEnabled = self.orders[indexPath.row].IsEnabled()
        
        return cell
    }    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
