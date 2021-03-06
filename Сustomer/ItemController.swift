//
//  ItemController.swift
//  WishMaker
//
//  Created by maxik on 01.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class ItemController: UIViewController {
  
 /* @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var descField: UITextView!
  @IBOutlet weak var priceField: UITextField!
  */
  @IBOutlet weak var priceField: UITextField!
  @IBOutlet weak var addressField: UITextField!
  
  @IBOutlet weak var descField: UITextView!
  @IBOutlet weak var titleField: UITextField!
  var latitude:String?
  var longtitude:String?
  
  let order = OrderModel()

  
  func addOrder () {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let path = "\(URLs.host)rpc/add_order"
    let headers: HTTPHeaders = ["Accept":"application/json","Authorization":appDelegate.authToken!]
    let params: Parameters = [
      "iduser": appDelegate.myId!,
      "tittle": self.order.title!,
      "descr": self.order.desc!,
      "pprice": self.order.price!,
      "addr": self.order.address!,
      "lat": self.order.latitude ?? String(describing: "") ,
      "longt": self.order.longtitude ?? String(describing: "")
    ]
    
    Alamofire.request(URL(string: path)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
      .responseJSON (){ response in
        debugPrint("answer####: \(response) ####end answer")
        let statusCode: Int? = response.response?.statusCode
        guard response.result.isSuccess else {
          if (statusCode != nil){
            debugPrint("Status code: \(statusCode) \nError while fetching remote rooms: \(response.result.error)")
          }
          ShowAlert.notifyUser("Error", message: "Can't publish order!", controller: self)
          return
        }
    }
  }
  
  @IBAction func addButtonTouched(_ sender: Any) {
    //correct
    //let desc = "asdasdaasd"
    
    print("\(self.longtitude) \(self.latitude)")
    
    guard let title = titleField.text,
      let address = addressField.text,
      let desc = descField.text,
      let sPrice = priceField.text,
      let price = Int(sPrice),
      price > 0, price < 1000000, desc.characters.count < 1024 else {
        ShowAlert.notifyUser("Error", message: "Wrong fields content!", controller: self)
        return
    }
    
    self.order.title = title
    self.order.desc =  desc
    self.order.price = price
    self.order.address = address
    self.order.longtitude = self.longtitude
    self.order.latitude = self.latitude

    //lat long id
    self.addOrder()
    
  }
  //Calls this function when the tap is recognized.
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ItemController.dismissKeyboard))
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier  == "attachLocationSegue"  {
      if let mapVC = segue.destination as? MappingViewController {
        mapVC.delegate = self
      }
    }
    else {
      print ("\n\n\n\n\n\n ERROOOOOOOOOOOOOOOOR \n\n\n\n\n")
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
