//
//  AlertsFile.swift
//  WishMaker
//
//  Created by mr.phaet0n on 5/7/17.
//  Copyright © 2017 Company. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON
/*
 Alamofire.request("https://httpbin.org/get")
 .validate(statusCode: 200..<300)
 .validate(contentType: ["application/json"])
 .responseData { response in
 switch response.result {
 case .success:
 print("Validation Successful")
 case .failure(let error):
 print(error)
 }
 }
 
 
 URL(string: "http://localhost:5984/rooms/_all_docs")!,
 method: .get,
 parameters: ["include_docs": "true"])
 .validate()
 .responseJSON { (response) -> Void in
 guard response.result.isSuccess else {
 print("Error while fetching remote rooms: \(response.result.error)")
 completion(nil)
 return
 }
 
 guard let value = response.result.value as? [String: Any],
 let rows = value["rows"] as? [[String: Any]] else {
 print("Malformed data received from fetchAllRooms service")
 completion(nil)
 return
 }
 
 let rooms = rows.flatMap({ (roomDict) -> RemoteRoom? in
 return RemoteRoom(jsonData: roomDict)
 })
 
 completion(rooms)
 
 // handle the results as JSON
 let todo = JSON(value)
 // now we have the results, let's just print them though a tableview would definitely be better UI:
 print("The todo is: " + todo.description)
 guard let title = todo["title"].string else {
 print("error parsing /todos/1")
 return
 }
 // to access a field:
 print("The title is: " + title
 }
 */

public class ShowAlert {
  public static func notifyUser(_ title: String, message: String, controller: UIViewController) -> Void
  {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
    {
      (result : UIAlertAction) -> Void in
    }
    alertController.addAction(okAction)
    controller.present(alertController, animated: true, completion: nil)
  }
}

public class URLs {
  public static let host = "http://wishmaker.ddns.net:3000/"
}



//
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


