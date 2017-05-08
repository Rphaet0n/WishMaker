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

public class AuthHelper {
  public static func isTokenValid(_ token: String, controller: UIViewController) -> Bool
  {
    let semaphore = DispatchSemaphore(value: 0)
    var result = false
    let params: Parameters = ["Accept":"application/json"]
    let headers: HTTPHeaders = [
      "Authorization": token]
    
    Alamofire.request("\(URLs.host)order_infos", method: .get, parameters: nil, headers: headers)
      .responseJSON { response in
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
    semaphore.wait(timeout: .now() + 5.0)
    return result
  }
}


