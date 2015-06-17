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
   
   class func timelineCellDeleteButton() -> UIButton
   {
      let deleteButton = UIButton.buttonWithType(.Custom) as! UIButton
      
      let title = NSAttributedString(string: "delete", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      deleteButton.setAttributedTitle(title, forState: .Normal)
      deleteButton.setBackgroundImage(UIImage.imageWithColor(UIColor.darkRedLipstickColor()), forState: .Normal)
      deleteButton.setBackgroundImage(UIImage.imageWithColor(UIColor.darkRedLipstickColor().colorWithAlphaComponent(0.6)), forState: .Highlighted)
      
      return deleteButton
   }
   
   class func timelineCellToggleButton() -> UIButton
   {
      let toggleButton = UIButton.buttonWithType(.Custom) as! UIButton
      let title = NSAttributedString(string: "toggle", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      toggleButton.setAttributedTitle(title, forState: .Normal)
      toggleButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lipstickRedColor()), forState: .Normal)
      toggleButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lipstickRedColor().colorWithAlphaComponent(0.6)), forState: .Highlighted)
      
      return toggleButton
   }
}
