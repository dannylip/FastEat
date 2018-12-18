//
//  Restaurant.swift
//  FastEat
//
//  Created by Danny LIP on 4/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Restaurant {
    
    var restName: String
    var restImageUrl: String
    var foodType: String
    var address: String
    var menus = [Menu]()
    
    init(json: JSON = JSON()) {
        self.restName = json["restaurant"].stringValue
        self.restImageUrl = json["imageUrl"].stringValue
        self.foodType = json["foodType"].stringValue
        self.address = json["address"].stringValue
        
        for menuArray in json["menus"].arrayValue {
            let menu = Menu(json: menuArray)
            menus.append(menu)
        }
    }
}
