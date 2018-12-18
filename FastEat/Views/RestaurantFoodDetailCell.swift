//
//  RestaurantFoodDetailCell.swift
//  FastEat
//
//  Created by Danny LIP on 12/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit

class RestaurantFoodDetailCell: UITableViewCell {
    
    @IBOutlet weak var foodItemLbl: UILabel!
    @IBOutlet weak var foodPriceLbl: UILabel!
    @IBOutlet weak var foodCountLabel: UILabel!
    
    func setupFoodDetailCell(foodItem: FoodItem) {

        foodItemLbl.text = foodItem.name
        foodPriceLbl.text = "$\(String(format: "%.2f", foodItem.price))"
        
        foodCountLabel.layer.cornerRadius = 10
        foodCountLabel.layer.masksToBounds = true
        
        if foodItem.quantity > 0 {
            foodCountLabel.isHidden = false
            foodCountLabel.text = "x\(foodItem.quantity)"
            self.accessoryType = .checkmark
        } else {
            foodCountLabel.isHidden = true
            self.accessoryType = .none
        }
    }
}
