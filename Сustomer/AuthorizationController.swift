//
//  ViewController.swift
//  Сustomer
//
//  Created by maxik on 23.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire

class AutorizationController: UIViewController {
    
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passField: UITextField!
  
  //Alert windows
  func notifyUser(_ title: String, message: String) -> Void
  {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
    {
      (result : UIAlertAction) -> Void in
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func signInTouched(_ sender: Any) {
    if loginField.text!.isEmpty && passField.text!.isEmpty{
      notifyUser("Error", message: "Login and password couldn't be empty!")
      return
    }
    // login/pass
    let params: Parameters = [
      "username": loginField.text!,
      "pass": passField.text!
    ]
    let headers: HTTPHeaders = ["Content-Type":"application/json"]

    
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
    Alamofire.request(URL(string: "http://0.0.0.0:3000/rpc/login")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON { response in
        debugPrint("answer####: \(response) ####end answer")
        
        guard response.result.isSuccess, let value = response.result.value  else {
          print("Error while fetching remote rooms: \(response.result.error)")
          return
        }
        //let json = value as!
        //print("Result:## \(json)")
        
    }

  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      passField.isSecureTextEntry = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
