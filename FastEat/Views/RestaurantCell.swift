//
//  RestaurantCell.swift
//  
//
//  Created by Danny LIP on 5/11/2018.
//

import UIKit
import AlamofireImage

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var restDeliveryTimeLbl: UILabel!
    @IBOutlet weak var restImageView: UIImageView!
    @IBOutlet weak var restNameLbl: UILabel!
    @IBOutlet weak var restDetailLbl: UILabel!
    
    func setupRestaurant(restaurant: Restaurant) {
        
        restDeliveryTimeLbl.layer.cornerRadius = 20
        
        if let imageUrl = URL(string: restaurant.restImageUrl){
            restImageView.af_setImage(withURL: imageUrl)
        } else {
            restImageView.image = UIImage()
        }
        restNameLbl.text = restaurant.restName
        restDetailLbl.text = "\(restaurant.foodType)・\(restaurant.address)"

    }
    
    private var isEnabledAnimation = true

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        if !isEnabledAnimation {
            return
        }

        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0, animations: {
                            self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
    
}
