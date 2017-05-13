//
//  CustomerViewController.swift
//  WishMaker
//
//  Created by maxik on 08.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController, ImageLoadProtocol {
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    var user : UserModel?
    var userInfoModel: UserInfoModel?
    var userId: Int?
    
    @IBOutlet weak var avatarView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let token = appDelegate.authToken!
        userInfoModel = UserInfoModel(userId!, token: token)
        userInfoModel!.delegate = self
        userInfoModel!.downloadItems()
    }
    
    func itemsDownloaded(items: NSArray) {
        guard items.count > 0, let user = items[0] as? UserModel else {
            debugPrint("Cant cast to UserModel !")
            return
        }
      self.user = user
      self.avatarView.image = user.avatar ?? #imageLiteral(resourceName: "default_profile")
      /*
      if user.avatar != nil {
        self.avatarView.image = user.avatar
      }
      else {
        self.avatarView.image = #imageLiteral(resourceName: "default_profile")
      }
 */
        self.name.text = user.fullName
        self.rating.text = user.rating
        self.phone.text = user.mobileNo
        //fill fields
    }
    
    func imagesLoaded(completed: Bool){

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
