//
//  FoodItem.swift
//  FastEat
//
//  Created by Danny LIP on 24/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FoodItem {
    
    var name: String
    var price: Double
    var quantity = 0
    
    init(json: JSON = JSON()) {
        self.name = json["name"].stringValue
        self.price = json["price"].doubleValue
    }
}
