//
//  UserModel.swift
//  WishMaker
//
//  Created by student on 03.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import UIKit


class UserModel: NSObject {
  
    //properties
    var idUser: Int?
    var fullName: String?
    var mobileNo: String?
    var rating: Double?
    var avatar: UIImage?
    
    //empty constructor
    override init()
    {
    }
    
    //construct with @idUser, @fullName, @mobileNo, @rating, and @avatar parameters
    init(idUser: Int, fullName: String, mobileNo: String, rating: Double, avatar: UIImage? = nil) {
        self.idUser = idUser
        self.fullName = fullName
        self.mobileNo = mobileNo
        self.rating = rating
        self.avatar = avatar
    }
    
    //prints object's current state
    override var description: String {
        return "idUser: \(idUser), fullName: \(fullName), mobileNo: \(mobileNo), rating: \(rating)"
    }
    
}
