//
//  ViewController.swift
//  Сustomer
//
//  Created by maxik on 23.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AutorizationController: UIViewController {
  
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passField: UITextField!
  
  var token: String?
  var uid: Int?
  var username: String?
  var validated = false
  
  func saveAppData() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.authToken = self.token!
    appDelegate.userName = self.username!
    appDelegate.myId = self.uid!
  }
  
  func loadData(){
    // login/pass
    let params: Parameters = [
      "username": self.username!,
      "pass": passField.text!
    ]
    let headers: HTTPHeaders = ["Content-Type":"application/json"]
    Alamofire.request("\(URLs.host)rpc/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON { response in
        debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess, statusCode == 200, let value = response.result.value else {
          if (statusCode != nil){
            switch statusCode! {
            case 403:  ShowAlert.notifyUser("Error", message: "Wrong login or password!", controller: self)
            default: print("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
            }
            
          } else{
            ShowAlert.notifyUser("Connection error", message: "Server down or internet connection is bad", controller: self)
          }
          return
        }
        let json = JSON(value)
        self.token =  "Bearer \(json[0]["token"].string!)"
        self.loadID()
    }
  }
  
  func loadID() {
    //Getting user_id
    let params: Parameters = [
      "username": self.username!
    ]
    let headers: HTTPHeaders = ["Content-Type":"application/json"]
    Alamofire.request(URL(string: "\(URLs.host)rpc/get_id")!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
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
        
        guard let json = JSON(value).dictionary, let answer = json["id_user"]?.int else {
          return
        }
        self.uid = answer
        self.signIn()
    }
  }
  
  func signIn () {
    guard self.token != nil, self.uid != nil else {
      ShowAlert.notifyUser("Error", message: "Sync error, learn about concurrency, bro!", controller: self)
      return
    }
    saveAppData()
    
    //save token
    let defaults = UserDefaults.standard
    defaults.set(self.token!, forKey: "authToken")
    defaults.set(self.uid!, forKey: "myId")
    defaults.set(self.username!, forKey: "username")
    self.performSegue(withIdentifier: "singInSegue", sender: self)
  }
  
  @IBAction func signInTouched(_ sender: Any) {
    if loginField.text!.isEmpty && passField.text!.isEmpty{
      ShowAlert.notifyUser("Error", message: "Login and password couldn't be empty!", controller: self)
      return
    }
    self.username = loginField.text!.lowercased()
    loadData()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    if validated {
      self.performSegue(withIdentifier: "singInSegue", sender: self)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    passField.isSecureTextEntry = true
    
    
    let defaults = UserDefaults.standard
    guard let token = defaults.string(forKey: "authToken"),
      let suid = defaults.string(forKey: "myId"),
      let uid = Int(suid),
      let username = defaults.string(forKey: "username") else {
        debugPrint("No stored config found!")
        return
    }
    let tokenIsValid = AuthHelper.isTokenValid(token, controller: self)
    debugPrint("Token is valid \(tokenIsValid) !")
    if tokenIsValid {
      self.token = token
      self.uid = uid
      self.username = username
      saveAppData()
      self.validated = true
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
