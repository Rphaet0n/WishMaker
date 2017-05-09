//
//  OrderModel.swift
//  WishMaker
//
//  Created by student on 03.05.17.
//  Copyright © 2017 Company. All rights reserved.
//

import Foundation
import UIKit


class OrderModel: NSObject {
    
    //properties
    var idOrder: Int?
    var title: String?
    var desc: String?
    var price: Int?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var images: [UIImage] = []
    var startDate: Date?
    var endDate: Date?
    var idExecutor: Int?
    
    //empty constructor
    override init()
    {
    }
    
    //construct with @idOrder, @title, @city, and @price parameters
    init(_ idOrder: Int, title: String, address: String, price: Int, startDate: Date) {
        self.idOrder = idOrder
        self.title = title
        self.address = address
        self.price = price
        self.startDate = startDate
    }
    
    //prints object's current state
    override var description: String {
        return "idOrder: \(idOrder), title: \(title), address: \(address), price: \(price), startDate: \(startDate)"
        
    }
    
    //is used
    func IsEnabled() -> Bool{
        if self.idExecutor == nil {
            return false
        }
        else {
            return true
        }
    }
    
    //get executor
    func getWorker (_ idExecutor:Int) {
        self.idExecutor = idExecutor
    }
}
