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

  init(_ uid: Int, token: String){
    self.path = "\(URLs.host)search_order?id_customer=not.eq.\(uid)&id_executor=not.eq.\(uid)"
    self.token = token
  }
  
  func downloadItems() {

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
          return
        }
        
        for dict in json {
          if let dic = dict.dictionary {
            print(String(describing: dic["title"]!))
          }
        }
        

    }
  }
  
}
