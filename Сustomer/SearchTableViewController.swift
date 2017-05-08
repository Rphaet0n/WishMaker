//
//  SearchTableViewController.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var tableData: Array<OrderModel>?
    
    
    // For Ardashes
    func creatAllOrders() -> Array<OrderModel>
    {
        return Array<OrderModel>()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableData = creatAllOrders()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell")! as! SearchTableViewCell
        cell.title?.text = tableData![indexPath.row].title
        cell.address?.text = tableData![indexPath.row].address
        cell.price?.text = "\(tableData![indexPath.row].price)"
        return cell
    }
}
