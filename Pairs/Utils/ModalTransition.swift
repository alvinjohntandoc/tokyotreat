//
//  ModalShowAnimator.swift
//  Pairs
//
//  Created by Alvin John Tandoc on 07/08/2018.
//  Copyright © 2018 Tokyo Treat. All rights reserved.
//

import UIKit

class ModalShowAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {return}
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        transitionContext.containerView.addSubview(fromViewController.view)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = transitionContext.containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        transitionContext.containerView.addSubview(blurEffectView)
        
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.frame = CGRect(x: 0, y: transitionContext.containerView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0,
                       options: .allowUserInteraction, animations: { () -> Void in
                        blurEffectView.alpha = 1.0
                        toViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (_) in
            blurEffectView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


class ModalHideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = transitionContext.containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1.0
        transitionContext.containerView.addSubview(blurEffectView)
        
        
        transitionContext.containerView.insertSubview(blurEffectView, belowSubview: fromViewController.view)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            fromViewController.view.frame = CGRect(x: 0, y: transitionContext.containerView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            blurEffectView.alpha = 0
        }) { (_) in
            if !UIApplication.shared.keyWindow!.subviews.contains(toViewController.view) {
                UIApplication.shared.keyWindow!.addSubview(toViewController.view)
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
