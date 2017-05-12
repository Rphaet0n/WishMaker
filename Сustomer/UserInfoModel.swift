//
//  UserInfoModel.swift
//  WishMaker
//
//  Created by student on 10.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol ImageLoadProtocol: ModelProtocol {
  func imagesLoaded(completed: Bool)
}

class UserInfoModel: NSObject{
  
  //properties
  weak var delegate: ImageLoadProtocol!
  
  var data : NSMutableData = NSMutableData()
  let path : String
  let token: String
  let uid: Int
  let users = NSMutableArray()
  
  init(_ uid: Int, token: String){
    self.path = "\(URLs.host)user_infos?id_user=eq.\(uid)"
    self.token = token
    self.uid = uid
  }
  
  func updateAvatar (avatar: String) {
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
    let params: Parameters = ["avatar" : avatar]
    Alamofire.request(URL(string: self.path)!, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON (){ response in
        //debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          } else{
            //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
          }
          self.delegate.imagesLoaded(completed: false)
          return
        }
        self.delegate.imagesLoaded(completed: true)
    }
  }
  
  
  func downloadItems() {
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
    Alamofire.request(URL(string: self.path)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
      .responseJSON (){ response in
        //debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess, statusCode == 200, let value = response.result.value else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          } else{
            //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
          }
          return
        }
        
        guard let json = JSON(value).array, json.count > 0  else {
          debugPrint("#####Error: can't parse JSON to ARRAY!")
          return
        }
        
        guard let dic = json[0].dictionary, let idUser = dic["id_user"]?.int,
          let fullName = dic["full_name"]?.string, let mobileNo = dic["mobile_no"]?.string,
          let rating = dic["rating"]?.double else {
            debugPrint("#####Error: user info parse error!")
            return
        }
        let avatar = dic["avatar"]?.string ?? ""
        let user = UserModel(idUser, fullName: fullName, mobileNo: mobileNo, rating: String(rating), avatar: ImageConverter.StringToUIImage(avatar))
        self.users.add(user)
        self.delegate.itemsDownloaded(items: self.users)
    }
  }
}


