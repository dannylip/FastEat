//
//  Menu.swift
//  FastEat
//
//  Created by Danny LIP on 24/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Menu {
    
    var sectionName: String
    var foodItems = [FoodItem]()
    
    init(json: JSON = JSON()) {
        self.sectionName = json["sectionName"].stringValue
        for foodItemArray in json["foodItems"].arrayValue {
            let foodItem = FoodItem(json: foodItemArray)
            foodItems.append(foodItem)
        }
    }
}
