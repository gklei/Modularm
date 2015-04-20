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
   class func cancelButtonWithTitle(title: String) -> UIButton
   {
      let cancelButton = UIButton()
      var attrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!, NSForegroundColorAttributeName : UIColor.lightGrayColor()]
      var highlightedAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!,
         NSForegroundColorAttributeName : UIColor(white: 0.8, alpha: 1)]
      
      let normalAttrTitle = NSAttributedString(string: title, attributes: attrs)
      let hightlightedAttrTitle = NSAttributedString(string: title, attributes: highlightedAttrs)
      
      cancelButton.setAttributedTitle(normalAttrTitle, forState: .Normal)
      cancelButton.setAttributedTitle(hightlightedAttrTitle, forState: .Highlighted)
      
      cancelButton.sizeToFit()
      return cancelButton
   }
}
