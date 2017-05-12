//
//  OrderViewController.swift
//  WishMaker
//
//  Created by mr.phaet0n on 5/12/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, FullOrderProtocol {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imagesView: UIImageView!
  @IBOutlet weak var descField: UITextView!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  @IBOutlet weak var customerButton: AllButtons!
  
  var order: OrderModel!
  
  func orderLoaded(order: OrderModel){
    self.order = order
    self.updateScreen()
  }
  
  func updateScreen() {
    //correct for photo
    self.titleLabel.text = order.title
    self.descField.text = order.desc
    self.addressLabel.text = order.address
    self.priceLabel.text = String(describing: order.price!)
    self.customerButton.setTitle(order.customerName, for: .normal)
  }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.customerButton?.titleLabel?.text = order.customerName
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fullOrderModel = FullOrderModel(self.order!, token: appDelegate.authToken!)
        fullOrderModel.delegate = self
        fullOrderModel.downloadFullOrder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showLocationSegue" {
      guard let lat = self.order.latitude,
      let longt = self.order.longtitude,
      let latcor = Double(lat),
      let longtcor = Double(longt) else {
        ShowAlert.notifyUser("Sorry", message: "Customer didn't attached location!", controller: self)
        return
      }
      if let dest = segue.destination as? MappinForExecutorViewController {
        dest.longt = longtcor
        dest.lat = latcor
      }
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
