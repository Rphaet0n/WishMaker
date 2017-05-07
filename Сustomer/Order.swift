//
//  Order.swift
//  WishMaker
//
//  Created by maxik on 07.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

class Order {
    var item: OrderModel
    var IdWorker: Int
    
    
    //construct with @Iname, @Icount, @city, and @price parameters
    init(item: OrderModel) {
        self.item = item
        self.IdWorker = (-1)
    }
    
    func IsEnabled() -> Bool{
        if IdWorker == (-1) {
            return false
        }
        else {
            return true
        }
    }
    
    func getWorker (_ idworker:Int) {
        self.IdWorker = idworker
    }
    
}
