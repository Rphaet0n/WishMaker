//
//  ViewController.swift
//  Сustomer
//
//  Created by maxik on 23.04.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
  
  @IBOutlet weak var phoneTextField: MaskField!
  
  @IBOutlet weak var loginField: UITextField!
  @IBOutlet weak var passField: UITextField!
  @IBOutlet weak var confirmField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signUpTouched(_ sender: Any) {
    if loginField.text!.isEmpty || passField.text!.isEmpty ||
      confirmField.text!.isEmpty || phoneTextField!.text!.isEmpty {
      ShowAlert.notifyUser("Error", message: "All fields must be filled!", controller: self)
      return
    }
    
    guard passField.text! == confirmField.text! else {
      ShowAlert.notifyUser("Error", message: "Confrimation and password aren't same!", controller: self)
      return
    }
  }
}
