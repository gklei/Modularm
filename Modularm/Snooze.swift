//
//  SnoozeModel.swift
//  Modularm
//
//  Created by Klein, Greg on 4/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum SnoozeDuration: Int16 {
   case FiveMinutes = 5
   case TenMinutes = 10
   case FifteenMinutes = 15
   case TwentyMinutes = 20
}

enum SnoozeType: Int16 {
   case RegularButton, BigButton, ShakePhone
}

@objc(Snooze)
class Snooze: NSManagedObject
{
   @NSManaged var durationValue: Int16
   @NSManaged var typeValue: Int16
   
   var type: SnoozeType {
      get {
         return SnoozeType(rawValue: self.typeValue)!
      }
      set {
         self.typeValue = newValue.rawValue
      }
   }
   
   var duration: SnoozeDuration {
      get {
         return SnoozeDuration(rawValue: self.durationValue)!
      }
      set {
         switch newValue.rawValue
         {
         case 5, 10, 15, 20:
            self.durationValue = newValue.rawValue
            break
         default:
            break
         }
      }
   }
   
   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      
      self.type = .RegularButton
      self.duration = .FiveMinutes
   }
}
