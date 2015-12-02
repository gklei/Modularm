//
//  UIStoryboard+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 5/12/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UIStoryboard
{
   static func controllerWithIdentifier(identifier: String) -> AnyObject
   {
      return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
   }
   
   static func alarmConfigurationController() -> AlarmConfigurationController
   {
      return UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
   }
}
