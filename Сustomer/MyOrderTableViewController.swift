//
//  MyOrderTableViewController.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class MyOrderTableViewController: UITableViewController, ModelProtocol {
  
  //var tableData: Array<OrderModel>?
  
  var tableData : Array<OrderModel> = Array<OrderModel> ()
  var selectedOrder = OrderModel()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let token = appDelegate.authToken!
    let uid = appDelegate.myId!
    let url = "\(URLs.host)search_order?id_customer=eq.\(uid)"
    let listModel = OrderListModel(uid, token: token, url: url)
    listModel.delegate = self
    listModel.downloadItems()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func itemsDownloaded(items: NSArray) {
    tableData = items as! Array<OrderModel>
    self.tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tableData.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MyOrdersViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "myOrderCell")! as! MyOrdersViewCell
    let order = tableData[indexPath.row] 
    cell.title.text = order.title!
    cell.checking.isEnabled = order.status == OrderStatus.processing.rawValue
    if cell.checking.isEnabled {
      cell.checking.borderColor = .green
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
  {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {
      tableData.remove(at: indexPath.row)
      self.tableView.reloadData()
    }
  }
  
  
}
