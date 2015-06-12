//
//  UILabel+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 6/12/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UILabel
{
   class func timeIntervalLabelWithText(text: String) -> UILabel
   {
      let hourLabel = UILabel()
      if let font = UIFont(name: "HelveticaNeue", size: 15)
      {
         hourLabel.font = font
      }
      
      hourLabel.text = text
      hourLabel.textColor = UIColor.whiteColor()
      
      hourLabel.sizeToFit()
      return hourLabel
   }
}