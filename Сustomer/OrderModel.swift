//
//  OrderModel.swift
//  WishMaker
//
//  Created by student on 03.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


enum OrderStatus: String {
  case active = "active"
  case done = "done"
  case failed = "failed"
  case processing = "processing"
}

class OrderModel: NSObject {
  
  //properties
  
  var title: String?
  var desc: String?
  var price: Int?
  var address: String?
  var images: [UIImage] = []
  var startDate: String?
  //customer  name
  
  var latitude: String?
  var longtitude: String?
  
  var endDate: String?
  var idExecutor: Int?
  var idOrder: Int?
  var status: String?
  var customerName: String?
    var idCustomer: Int?
  
  //empty constructor
  override init()
  {
  }
  
  //construct with @idOrder, @title, @city, and @price parameters
  init(_ idOrder: Int, title: String, address: String, price: Int, startDate: String, idExecutor: Int) {
    self.idOrder = idOrder
    self.title = title
    self.address = address
    self.price = price
    self.startDate = startDate
    self.idExecutor = idExecutor
  }
  
  //prints object's current state
  override var description: String {
    return "idOrder: \(idOrder), title: \(title), address: \(address), price: \(price), startDate: \(startDate)"
    
  }
  
  //is used
  func IsEnabled() -> Bool{
    if self.idExecutor == nil {
      return false
    }
    else {
      return true
    }
  }
  
  //get executor
  func getWorker (_ idExecutor:Int) {
    self.idExecutor = idExecutor
  }
}




