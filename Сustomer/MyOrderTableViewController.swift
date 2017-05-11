//
//  MyOrderTableViewController.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class MyOrderTableViewController: UITableViewController {
    
    
    var orders: Array<OrderModel>?
    
    // For Ardashes
    func loadMyOrders () -> Array<OrderModel> {
        
        return Array<OrderModel> ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orders = loadMyOrders()
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "myOrderCell", for: indexPath) as! MyOrdersViewCell
        
        cell.title.text = self.orders?[indexPath.row].title
        cell.checking.isEnabled = (self.orders?[indexPath.row].IsEnabled())!
        if (cell.checking.isEnabled) {
            cell.checking.borderColor = .red
        }
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
