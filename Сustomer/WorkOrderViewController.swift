//
//  WorkOrderViewController.swift
//  WishMaker
//
//  Created by maxik on 12.05.17.
//  Copyright © 2017 Company. All rights reserved.
//
//

import UIKit

class WorkOrderViewController: UIViewController, FullOrderProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var customerButton: AllButtons!
    @IBOutlet weak var disagree: AllButtons!
    
    var order: OrderModel!
    
    var fullOrderModel : FullOrderModel?
    
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
        self.disagreeButtonTouched.isEnabled = (self.order.status != OrderStatus.done.rawValue)
        if !self.disagreeButtonTouched.isEnabled {
            self.disagreeButtonTouched.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.fullOrderModel = FullOrderModel(self.order!, token: appDelegate.authToken!)
        self.fullOrderModel?.delegate = self
        self.fullOrderModel?.downloadFullOrder()
        
    }
    
    @IBOutlet weak var disagreeButtonTouched: AllButtons!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWorkLocationSegue" {
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
        } else if segue.identifier == "disagreeSegue" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let isCanceled = self.fullOrderModel?.disagreeOrder(appDelegate.myId!)
            guard isCanceled! else {
                ShowAlert.notifyUser("Error", message: "Couldn't cancel order!", controller: self)
                return
            }
        } else if segue.identifier == "fromWorkProfileSegue" {
            if let profVC = segue.destination as? CustomerViewController {
                profVC.userId = order.idCustomer!
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
