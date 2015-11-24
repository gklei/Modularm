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
   
   var originalImage: UIImage {
      get {
         return self.imageWithRenderingMode(.AlwaysOriginal)
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
   
   class func imageWithImage(image:UIImage, scaledToSize size:CGSize) -> UIImage{
      UIGraphicsBeginImageContext(size)
      image.drawInRect(CGRectMake(0, 0, size.width, size.height))
      let result = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return result
   }
   
   convenience init?(option: AlarmOption)
   {
      var imageName = ""
      switch option
      {
      case .Countdown:
         imageName = "icn-countdown"
         break
      case .Date:
         imageName = "icn-date"
         break
      case .Music:
         imageName = "icn-music"
         break
      case .Repeat:
         imageName = "icn-repeat"
         break
      case .Snooze:
         imageName = "icn-snooze"
         break
      case .Sound:
         imageName = "icn-alarm-sound"
         break
      case .Weather:
         imageName = "icn-weather"
         break
      case .Message:
         imageName = "icn-message"
         
      default: // Unknown
         break
      }
      
      self.init(named: imageName)
   }
}
