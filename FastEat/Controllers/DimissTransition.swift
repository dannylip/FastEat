//
//  DimissTransition.swift
//  FastEat
//
//  Created by Danny LIP on 5/1/2019.
//  Copyright © 2019 Danny LIP. All rights reserved.
//

import Foundation
import UIKit

class DismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var toCellFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromView = transitionContext.view(forKey: .from) else { return }
//        guard let toView = transitionContext.viewController(forKey: .to) as? RestaurantListViewController else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containterView = transitionContext.containerView
        let finalFrame = toView.frame
        
        toView.frame = toCellFrame
        toView.clipsToBounds = true
        containterView.addSubview(toView)
        
        let closeBtnAndTableView = toView.subviews.filter { $0.tag == 1 }
        closeBtnAndTableView.forEach { $0.alpha = 0 }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       animations:
            {
                toView.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            closeBtnAndTableView.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
}
