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
      hourLabel.numberOfLines = 0;
      
      hourLabel.sizeToFit()
      return hourLabel
   }
   
   class func largeTimeDisplayLabelWithAlignment(alignment: NSTextAlignment) -> UILabel
   {
      let label = UILabel()
      if let font = UIFont(name: "HelveticaNeue-Thin", size: 72)
      {
         label.font = font
      }
      label.textColor = UIColor.whiteColor()
      label.textAlignment = alignment
      return label
   }
}