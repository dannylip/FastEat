//
//  BasketListCell.swift
//  FastEat
//
//  Created by Danny LIP on 27/11/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import UIKit
import SnapKit

class BasketListCell: UITableViewCell {
    
    private let foodNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    private let foodPriceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let foodQuantityLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = UIColor(displayP3Red: 10.0/255.0, green: 200.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setupFoodDetailCell(foodItem: FoodItem) {
        
        foodNameLbl.text = foodItem.name
        foodPriceLbl.text = "$\(String(format: "%.2f", foodItem.price))"
        foodQuantityLbl.text = "x\(foodItem.quantity)"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(foodNameLbl)
        addSubview(foodQuantityLbl)
        addSubview(foodPriceLbl)
        
        foodNameLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(15)
            $0.width.equalTo(250)
            $0.height.equalTo(self.bounds.height/2)
        }
        
        foodPriceLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-15)
            $0.width.equalTo(70)
            $0.height.equalTo(self.bounds.height/2)
        }
        
        foodQuantityLbl.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(foodPriceLbl.snp.trailing).inset(85)
            $0.width.equalTo(30)
            $0.height.equalTo(self.bounds.height/2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
