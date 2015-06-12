//
//  TimeSetterTransitionAnimator.swift
//  Modularm
//
//  Created by Klein, Greg on 6/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimeSetterTransitionAnimator: NSObject
{
   let duration = 0.6
   var presenting = true
}

extension TimeSetterTransitionAnimator: UIViewControllerAnimatedTransitioning
{
   func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval
   {
      return self.duration
   }
   
   func animateTransition(transitionContext: UIViewControllerContextTransitioning)
   {
      let containerView = transitionContext.containerView()
      
      let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
      let timeSetterView = self.presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
      
      containerView.addSubview(toView)
      containerView.bringSubviewToFront(timeSetterView)
      
      timeSetterView.alpha = self.presenting ? 0 : 1
      UIView.animateWithDuration(self.duration, animations: { () -> Void in
         
         timeSetterView.alpha = self.presenting ? 1 : 0
         }) { (finished: Bool) -> Void in
            
            if !self.presenting {
               let controller = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController
               controller?.setNavigationBarHidden(false, animated: true)
            }
            transitionContext.completeTransition(true)
      }
   }
}
