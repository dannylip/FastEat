//
//  PresentTransition.swift
//  FastEat
//
//  Created by Danny LIP on 8/12/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

import Foundation
import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let containterView = transitionContext.containerView
        let finalFrame = toView.frame
        
        toView.frame = originFrame
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
