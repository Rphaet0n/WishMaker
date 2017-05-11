//
//  SearchTableViewController.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, ModelProtocol {
    
    //var tableData: Array<OrderModel>?
  
    var tableData : NSArray = NSArray()
    var selectedOrder = OrderModel()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let token = appDelegate.authToken!
      let uid = appDelegate.myId!
      let listModel = OrderListModel(uid, token: token)
      listModel.delegate = self
      listModel.downloadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  func itemsDownloaded(items: NSArray) {
    tableData = items
    self.tableView.reloadData()
  }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell")! as! SearchTableViewCell
        let order = tableData[indexPath.row] as! OrderModel
        cell.title?.text = order.title!
        cell.address?.text = order.address!
        cell.price?.text = "\(order.price!)"
        return cell
    }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    selectedOrder = tableData[indexPath.row] as! OrderModel
    // Manually call segue to detail view controller
    self.performSegue(withIdentifier: "fullOrderSegue", sender: self)
  }

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let orderVC  = segue.destination as! OrderViewController
    // Set the property to the selected location so when the view for
    // detail view controller loads, it can access that property to get the feeditem obj
    orderVC.order = selectedOrder
  }
  
}
