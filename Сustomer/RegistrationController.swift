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
  @IBOutlet weak var fullnameField: UITextField!
  
  
  //Calls this function when the tap is recognized.
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    // Do any additional setup after loading the view, typically from a nib.
    passField.isSecureTextEntry = true
    confirmField.isSecureTextEntry = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signUpTouched(_ sender: Any) {
    if loginField.text!.isEmpty || passField.text!.isEmpty ||
      confirmField.text!.isEmpty || phoneTextField!.text!.isEmpty ||
      fullnameField!.text!.isEmpty{
      ShowAlert.notifyUser("Error", message: "All fields must be filled!", controller: self)
      return
    }
    
    guard passField.text! == confirmField.text! else {
      ShowAlert.notifyUser("Error", message: "Confrimation and password aren't same!", controller: self)
      return
    }
    
    //correct fullname arg
    
    let regCompleted = AuthHelper.signUp(loginField.text!.lowercased(), pass: passField.text!, fullname: fullnameField!.text!, phoneNumber: phoneTextField.text!, controller: self)
    if regCompleted {
      self.performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    else {
      ShowAlert.notifyUser("Error", message: "Registration doesn't completed!", controller: self)
      
    }
  }
}
