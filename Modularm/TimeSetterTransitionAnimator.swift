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
   let duration = 0.4
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
      if self.presenting
      {
         self.animateTimeSetterInWithTransitionContext(transitionContext)
      }
      else
      {
         self.animateTimeSetterOutWithTransitionContext(transitionContext)
      }
   }
   
   private func animateTimeSetterInWithTransitionContext(context: UIViewControllerContextTransitioning)
   {
      let containerView = context.containerView()
      let timeSetterView = context.viewForKey(UITransitionContextToViewKey)!
      let configurationView = context.viewForKey(UITransitionContextFromViewKey)!
      
      containerView.addSubview(timeSetterView)
      containerView.bringSubviewToFront(configurationView)
      
      UIView.animateWithDuration(self.duration, animations: { () -> Void in
         configurationView.alpha = 0
         }) { (finished: Bool) -> Void in
            configurationView.alpha = 1
            context.completeTransition(true)
      }
   }
   
   private func animateTimeSetterOutWithTransitionContext(context: UIViewControllerContextTransitioning)
   {
      let containerView = context.containerView()
      
      let timeSetterView = context.viewForKey(UITransitionContextFromViewKey)!
      let configurationView = context.viewForKey(UITransitionContextToViewKey)!
      
      containerView.addSubview(configurationView)
      containerView.bringSubviewToFront(timeSetterView)
      
      UIView.animateWithDuration(self.duration, animations: { () -> Void in
         timeSetterView.alpha = 0
         }) { (finished: Bool) -> Void in
            timeSetterView.alpha = 1
            context.completeTransition(true)
      }
   }
}
