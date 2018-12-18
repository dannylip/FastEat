//
//  PresentTransition.swift
//  FastEat
//
//  Created by Danny LIP on 8/12/2018.
//  Copyright © 2018 Danny LIP. All rights reserved.
//

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
        let initialFrame = originFrame
        let finalFrame = toView.frame
        
        toView.frame = originFrame
        toView.layer.cornerRadius = 12
        toView.clipsToBounds = true
        //toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        containterView.addSubview(toView)
        
        let toViewContentView = toView.subviews.first { $0.tag == 99 }
        
        let imageView = toViewContentView?.subviews.first { $0 is UIImageView } as? UIImageView
        imageView?.frame = CGRect(x: 0, y: 0, width: originFrame.width, height: originFrame.height)
        imageView?.layer.cornerRadius = 12
        
        let closeBtn = toViewContentView?.subviews.first { $0 is UIButton } as? UIButton
        closeBtn?.alpha = 0
        
        let descLabel = toViewContentView?.subviews.first { $0 is UILabel } as? UILabel
        descLabel?.alpha = 0
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       animations:
            {
                toView.layer.cornerRadius = 0
                toView.frame = finalFrame
                
                imageView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 420 * (UIScreen.main.bounds.width) / (UIScreen.main.bounds.width - 32))
                imageView?.layer.cornerRadius = 0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            closeBtn?.alpha = 1
            descLabel?.alpha = 1
        }, completion: nil)
    }

}
