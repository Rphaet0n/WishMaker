//
//  AuthHelper.swift
//  WishMaker
//
//  Created by student on 10.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public class URLs {
    public static let host = "http://wishmaker.ddns.net:3000/"
}


public class AuthHelper {
    
    //Token checking function
    public static func isTokenValid(_ token: String, controller: UIViewController) -> Bool
    {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        let params: Parameters = ["Accept":"application/json"]
        let headers: HTTPHeaders = [
            "Authorization": token]
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire.request("\(URLs.host)categories", method: .get, parameters: nil, headers: headers)
            .responseJSON(queue: utilityQueue) { response in
                debugPrint("answer####: \(response) ####end answer")
                let statusCode: Int? = response.response?.statusCode
                guard response.result.isSuccess, statusCode == 200 else {
                    if (statusCode != nil){
                        ShowAlert.notifyUser("Error", message: "Token check eroor", controller: controller)
                        print("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
                    }else{
                        ShowAlert.notifyUser("Connection error", message: "Server down or internet connection is bad", controller: controller)
                    }
                    semaphore.signal()
                    return
                }
                result = true
                semaphore.signal()
        }
        semaphore.wait(timeout: .now() + 3.0)
        return result
    }
    
    
    //Registration function
    public static func signUp(_ uname: String, pass: String, fullname: String, phoneNumber: String, controller: UIViewController) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var regCompleted = false
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        var params: Parameters = [
            "pass":pass,
            "username": uname
            
        ]
        var headers: HTTPHeaders = ["Content-Type":"application/json"]
        Alamofire.request(URL(string: "\(URLs.host)rpc/signup")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: utilityQueue) { response in
                debugPrint("answer####: \(response) ####end answer")
                let statusCode: Int? = response.response?.statusCode
                guard response.result.isSuccess, statusCode == 200, let value = response.result.value else {
                    if (statusCode != nil){
                        switch statusCode! {
                        case 409:  ShowAlert.notifyUser("Error", message: "Username is busy, try another!", controller: controller)
                        default: debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
                        }
                    } else{
                        //self.notifyUser("Connection error", message: "Server down or internet connection is bad")
                    }
                    semaphore.signal()
                    return
                }
                regCompleted = true
                semaphore.signal()
        }
        
        semaphore.wait(timeout: .now() + 3.0)
        
        if !regCompleted {
            ShowAlert.notifyUser("Error", message: "Try again later!", controller: controller)
            return false
        }
        
        var token : String?
        
        Alamofire.request("\(URLs.host)rpc/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: utilityQueue) { response in
                debugPrint("answer####: \(response) ####end answer")
                let statusCode: Int? = response.response?.statusCode
                guard response.result.isSuccess, statusCode == 200, let value = response.result.value else {
                    if (statusCode != nil){
                        switch statusCode! {
                        case 403:  ShowAlert.notifyUser("Error", message: "Wrong login or password!", controller: controller)
                        default: debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
                        }
                        
                    } else{
                        ShowAlert.notifyUser("Connection error", message: "Server down or internet connection is bad", controller: controller)
                    }
                    semaphore.signal()
                    return
                }
                let json = JSON(value)
                token =  "Bearer \(json[0]["token"].string!)"
                semaphore.signal()
        }
        
        semaphore.wait(timeout: .now() + 3.0)
        
        if token == nil {
            ShowAlert.notifyUser("Error", message: "Token receivng fail!", controller: controller)
            return false
        }
        
        
        regCompleted = false
        headers["Authorization"] = token!
        
        params = [
            "username": uname,
            "fullname": fullname,
            "number" : phoneNumber
        ]
        
        Alamofire.request("\(URLs.host)rpc/addnumber", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(queue: utilityQueue) { response in
                debugPrint("answer####: \(response) ####end answer")
                let statusCode: Int? = response.response?.statusCode
                guard response.result.isSuccess, statusCode == 200, let _ = response.result.value else {
                    if (statusCode != nil){
                        switch statusCode! {
                        //case 403:  ShowAlert.notifyUser("Error", message: "Can't add fullname and phone number!", controller: controller)
                        default: debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
                        }
                        
                    } else{
                        ShowAlert.notifyUser("Connection error", message: "Server down or internet connection is bad", controller: controller)
                    }
                    semaphore.signal()
                    return
                }
                regCompleted = true
                semaphore.signal()
        }
        
        semaphore.wait(timeout: .now() + 3.0)
        
        if !regCompleted {
            ShowAlert.notifyUser("Error", message: "Can't add fullname and phone number!", controller: controller)
            return false
        }
        
        return true
    }
  
  
}
