//
//  Item.swift
//  WishMaker
//
//  Created by maxik on 06.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

class Item {
    var Iname: String?
    var Icount: Int?
    var Iaddress: String?
    var Iprice: Int?
    
    
    //construct with @Iname, @Icount, @city, and @price parameters
    init(Iname: String, Icount: Int, Iaddress: String, Iprice: Int) {
        self.Iname = Iname
        self.Icount = Icount
        self.Iaddress = Iaddress
        self.Iprice = Iprice
    }
    
}
