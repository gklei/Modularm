//
//  UIButton+Extensions.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UIButton
{
   class func grayButtonWithTitle(title: String) -> UIButton
   {
      let cancelButton = UIButton()
      
      let normalAttrTitle = NSAttributedString(text: title, color: UIColor.lightGrayColor())
      let hightlightedAttrTitle = NSAttributedString(text: title, color: UIColor(white: 0.8, alpha: 0.75))
      
      cancelButton.setAttributedTitle(normalAttrTitle, forState: .Normal)
      cancelButton.setAttributedTitle(hightlightedAttrTitle, forState: .Highlighted)
      
      cancelButton.sizeToFit()
      return cancelButton
   }
}
