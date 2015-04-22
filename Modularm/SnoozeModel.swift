//
//  SnoozeModel.swift
//  Modularm
//
//  Created by Klein, Greg on 4/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum SnoozeButtonType: Int16 {
   case Small, Medium, Large
}

@objc(SnoozeModel)
class SnoozeModel: NSManagedObject
{
   @NSManaged var duration: Int16
   @NSManaged var buttonTypeValue: Int16
   
   var buttonType: SnoozeButtonType {
      get {
         return SnoozeButtonType(rawValue: self.buttonTypeValue)!
      }
      set {
         self.buttonTypeValue = newValue.rawValue
      }
   }
}
