//
//  CategoryModel.swift
//  WishMaker
//
//  Created by mr.phaet0n on 5/9/17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ModelProtocol: class {
  func itemsDownloaded(items: NSArray)
}


class OrderListModel: NSObject{
  
  //properties
  weak var delegate: ModelProtocol!
  
  
  var data : NSMutableData = NSMutableData()
  let path : String
  let token: String
  
  let orders = NSMutableArray()

  init(_ uid: Int, token: String){
    self.path = "\(URLs.host)search_order?id_customer=not.eq.\(uid)&id_executor=not.eq.\(uid)"
    self.token = token
  }
  
  func downloadItems() {
    //(queue: DispatchQueue.global(qos: .utility))
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
    Alamofire.request(URL(string: self.path)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
      .responseJSON { response in
        debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess, statusCode == 200, let value = response.result.value else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          } else{
            //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
          }
          return
        }
        
        guard let json = JSON(value).array  else {
          debugPrint("#####Error: can't parse JSON to ARRAY!")
          return
        }
        
        for i in 0..<json.count {
          guard let dic = json[i].dictionary, let idOrder = dic["id_order"]?.int,
            let title = dic["title"]?.string, let address = dic["city"]?.string,
            let price = dic["price"]?.int, let startDate = dic["start_date"]?.string else {
              debugPrint("#####Error: current short order parse error!")
              return
          }
          let order = OrderModel(idOrder, title: title, address: address, price: price, startDate: Date())
           self.orders.add(order)
        }
        self.delegate.itemsDownloaded(items: self.orders)

    }
  }
  
}
