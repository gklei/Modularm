//
//  UINavigationBar+Additions.swift
//  Modularm
//
//  Created by Gregory Klein on 4/12/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

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

      let subviews = (view.subviews as! [UIView])
      for subview: UIView in subviews {
         if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
            return imageView
         }
      }
      return nil
   }
}
