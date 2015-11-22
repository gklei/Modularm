//
//  UINavigationBar+Additions.swift
//  Modularm
//
//  Created by Gregory Klein on 4/12/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UINavigationController
{
   func makeNavigationBarTransparent()
   {
      navigationBar.makeTransparent()
   }
   
   func setNavigationBarHairlineHidden(hidden: Bool)
   {
      if hidden {
         navigationBar.hideBottomHairline()
      }
      else {
         navigationBar.showBottomHairline()
      }
   }
}

extension UINavigationBar
{
   func hideBottomHairline()
   {
      let navigationBarImageView = hairlineImageViewInNavigationBar(self)
      navigationBarImageView!.hidden = true
   }

   func showBottomHairline()
   {
      let navigationBarImageView = hairlineImageViewInNavigationBar(self)
      navigationBarImageView!.hidden = false
   }

   private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView?
   {
      if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
         return (view as! UIImageView)
      }

      let subviews = (view.subviews )
      for subview: UIView in subviews {
         if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
            return imageView
         }
      }
      return nil
   }
   
   func makeTransparent()
   {
      self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      self.backgroundColor = UIColor.clearColor()
      self.translucent = true
   }
}
