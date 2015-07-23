//
//  File.swift
//  Modularm
//
//  Created by Klein, Greg on 7/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
   class func rightBarButtonItemWithTitle(title: String, color: UIColor) -> UIBarButtonItem
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      barButtonItem.tintColor = color
      
      let font = UIFont.systemFontOfSize(20)
      let attributes = [NSFontAttributeName : font]
      barButtonItem.setTitleTextAttributes(attributes, forState: .Normal)
      barButtonItem.setTitlePositionAdjustment(UIOffset(horizontal: -12, vertical: 0), forBarMetrics: .Default)
      
      return barButtonItem
   }
}
