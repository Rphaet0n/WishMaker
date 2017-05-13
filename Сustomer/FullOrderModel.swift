//
//  FullOrderModel.swift
//  WishMaker
//
//  Created by mr.phaet0n on 5/12/17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol FullOrderProtocol: class {
  func orderLoaded(order: OrderModel)
}

class FullOrderModel: NSObject{
  
  //properties
  weak var delegate: FullOrderProtocol!
  
  var data : NSMutableData = NSMutableData()
  let path : String
  let token: String
  let order: OrderModel
  
  //status
  //description
  //latitude
  //longtitude
  //end_date
  //images
  
  init(_ order: OrderModel, token: String){
    self.order = order
    self.path = "\(URLs.host)full_orders?id_order=eq.\(order.idOrder!)"
    self.token = token
  }
  
  func downloadFullOrder() {
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
        
        guard let json = JSON(value).array else {
          debugPrint("#####Error: can't parse JSON to ARRAY!")
          return
        }
        
        guard json.count > 0, let dic = json[0].dictionary, let _ = dic["id_order"]?.int else {
          debugPrint("#####Error: current full order parse error!")
          return
        }
        self.order.status = dic["status"]?.string
        self.order.desc = dic["description"]?.string
        self.order.latitude = dic["latitude"]?.string
        self.order.longtitude = dic["longtitude"]?.string
        self.order.customerName = dic["full_name"]?.string
        self.order.idCustomer = dic["id_customer"]?.int

        if let endDate = dic["end_date"]?.string {
          self.order.endDate =  ImageConverter.parseDate(endDate)
        }
        guard let images = dic["images"]?.array, images.count > 0 else {
          debugPrint("#####Error: images to array cast error!")
          //correct
          self.delegate.orderLoaded(order: self.order)
          return
        }
        for img in images {
          if let strImage = img.string, let uimage = ImageConverter.StringToUIImage(strImage) {
            self.order.images.append(uimage)
          }
        }
        self.delegate.orderLoaded(order: self.order)
    }
  }
  
  func acceptOrder(_ uid: Int) -> Bool {
    var result = false
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
    let acceptURL = "\(URLs.host)rpc/takeorder"
    let params : Parameters =
      ["id_user":uid, "id_order":self.order.idOrder!]
    let semaphore = DispatchSemaphore(value: 0)
    let utilityQueue = DispatchQueue.global(qos: .utility)
    Alamofire.request(URL(string: acceptURL)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON(queue: utilityQueue) { response in
        debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess, statusCode! < 301 else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          } else{
            //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
          }
          result = false
          semaphore.signal()
          return
        }
        result = true
        semaphore.signal() 
    }
    let _ = semaphore.wait(timeout: .now() + 3.0)
    return result
  }
  
  func disagreeOrder(_ uid: Int) -> Bool {
    var result = false
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
    let acceptURL = "\(URLs.host)rpc/failorder"
    let params : Parameters =
      ["id_user":uid, "id_order":self.order.idOrder!]
    let semaphore = DispatchSemaphore(value: 0)
    let utilityQueue = DispatchQueue.global(qos: .utility)
    Alamofire.request(URL(string: acceptURL)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON(queue: utilityQueue) { response in
        debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess, statusCode! < 300 else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          } else{
            //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
          }
          result = false
          semaphore.signal()
          return
        }
        result = true
        semaphore.signal()
    }
    let _ = semaphore.wait(timeout: .now() + 3.0)
    return result
  }
    
    func completeOrder(_ uid: Int) -> Bool {
        var result = false
        let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
        let acceptURL = "\(URLs.host)rpc/completeorder"
        let params : Parameters =
            ["id_user":uid, "id_order":self.order.idOrder!, "mark": 10]
        let semaphore = DispatchSemaphore(value: 0)
        let utilityQueue = DispatchQueue.global(qos: .utility)
        Alamofire.request(URL(string: acceptURL)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: utilityQueue) { response in
                debugPrint("answer####: \(response) ####end answer")
                let statusCode: Int? = response.response?.statusCode
                guard response.result.isSuccess, statusCode! < 300 else {
                    if (statusCode != nil){
                        debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
                    } else{
                        //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
                    }
                    result = false
                    semaphore.signal()
                    return
                }
                result = true
                semaphore.signal()
        }
        let _ = semaphore.wait(timeout: .now() + 3.0)
        return result
    }
}
