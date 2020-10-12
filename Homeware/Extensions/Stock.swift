//
//  stock.swift
//  Homeware
//
//  Created by Han-Pin on 2020/9/3.
//  Copyright © 2020 Han-Pin. All rights reserved.
//

import Foundation

class Stock {
    var name: String
    var image: String
    var quantity: Int
    var use: String
    var star: Bool
    
    init(name: String, image: String, quantity: Int, use: String, star: Bool) {
        self.name = name
        self.image = image
        self.quantity = quantity
        self.use = use
        self.star = star
    }
    
    convenience init() {
        self.init(name: "", image: "", quantity: 0, use: "", star: false)
    }
    
}
