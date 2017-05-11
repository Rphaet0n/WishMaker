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







//


