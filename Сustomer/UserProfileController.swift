//
//  UserProfileController.swift
//  WishMaker
//
//  Created by student on 10.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import UIKit

class UserProfileController: UIViewController, ModelProtocol {
    
    //var tableData: Array<OrderModel>?
    var user : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let token = appDelegate.authToken!
        let uid = appDelegate.myId!
        let userInfoModel = UserInfoModel(uid, token: token)
        userInfoModel.delegate = self
        userInfoModel.downloadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func itemsDownloaded(items: NSArray) {
        guard items.count > 0, let user = items[0] as? UserModel else {
            debugPrint("Cant cast to UserModel !")
            return
        }
        self.user = user
        
        //fill fields
        
    }
    
}
