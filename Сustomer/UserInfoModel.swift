//
//  UserInfoModel.swift
//  WishMaker
//
//  Created by student on 10.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

class UserInfoModel: NSObject{
    
    //properties
    weak var delegate: ModelProtocol!
    
    
    var data : NSMutableData = NSMutableData()
    let path : String
    let token: String
    
    let users = NSMutableArray()
    
    init(_ uid: Int, token: String){
        self.path = "\(URLs.host)user_infos?id_user=eq.\(uid)"
        self.token = token
    }
    
    func downloadItems() {
        (queue: DispatchQueue.global(qos: .utility))
        let headers: HTTPHeaders = ["Accept":"application/json","Authorization":token]
        Alamofire.request(URL(string: self.path)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON (queue: DispatchQueue.global(qos: .utility)){ response in
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
                
                    guard let dic = json[0].dictionary, let idUser = dic["id_user"]?.int,
                        let fullName = dic["full_name"]?.string, let mobileNo = dic["mobile_no"]?.string,
                        let rating = dic["rating"]?.string else {
                            debugPrint("#####Error: user info parse error!")
                            return
                    }
                    let avatar = dic["avatar"]?.string ?? ""
                    let user = UserModel(idUser, fullName: fullName, mobileNo: mobileNo, rating: rating, avatar: ImageConverter.StringToUIImage(avatar))
                    self.users.add(user)
                }
                self.delegate.itemsDownloaded(items: self.users)
        }
    }
    

