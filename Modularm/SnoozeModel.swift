//
//  SnoozeModel.swift
//  Modularm
//
//  Created by Klein, Greg on 4/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum SnoozeType: Int16 {
   case RegularButton, BigButton, ShakePhone
}

@objc(SnoozeModel)
class SnoozeModel: NSManagedObject
{
   @NSManaged var duration: Int16
   @NSManaged var snoozeTypeValue: Int16
   
   var snoozeType: SnoozeType {
      get {
         return SnoozeType(rawValue: self.snoozeTypeValue)!
      }
      set {
         self.snoozeTypeValue = newValue.rawValue
      }
   }
}
