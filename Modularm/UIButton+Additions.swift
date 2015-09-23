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
   
   class func buttonWithTitle(title: String, color: UIColor) -> UIButton
   {
      let button = UIButton()
      
      let normalAttrTitle = NSAttributedString(text: title, color: color)
      let hightlightedAttrTitle = NSAttributedString(text: title, color: color.colorWithAlphaComponent(0.7))
      
      button.setAttributedTitle(normalAttrTitle, forState: .Normal)
      button.setAttributedTitle(hightlightedAttrTitle, forState: .Highlighted)
      
      button.sizeToFit()
      return button
   }
   
   class func timelineCellDeleteButton() -> UIButton
   {
      let deleteButton = UIButton(type: .Custom)
      
      let title = NSAttributedString(string: "delete", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 15)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      deleteButton.setAttributedTitle(title, forState: .Normal)
      deleteButton.setBackgroundImage(UIImage.imageWithColor(UIColor.darkRedLipstickColor()), forState: .Normal)
      deleteButton.setBackgroundImage(UIImage.imageWithColor(UIColor.darkRedLipstickColor().colorWithAlphaComponent(0.8)), forState: .Highlighted)
      
      return deleteButton
   }
   
   class func timelineCellToggleButton() -> UIButton
   {
      let toggleButton = UIButton(type: .Custom)
      toggleButton.setImage(UIImage(named:"icn-standby"), forState: .Normal)
      toggleButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lipstickRedColor()), forState: .Normal)
      toggleButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lipstickRedColor().colorWithAlphaComponent(0.8)), forState: .Highlighted)
      
      return toggleButton
   }
}
