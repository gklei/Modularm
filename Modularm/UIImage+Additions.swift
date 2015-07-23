//
//  UIImage+Additions.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UIImage
{
   var templateImage: UIImage {
      get {
         return self.imageWithRenderingMode(.AlwaysTemplate)
      }
   }
   
   class func imageWithColor(color: UIColor) -> UIImage
   {
      let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
      UIGraphicsBeginImageContext(rect.size)
      let context = UIGraphicsGetCurrentContext()
      
      CGContextSetFillColorWithColor(context, color.CGColor)
      CGContextFillRect(context, rect)
      
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
}
