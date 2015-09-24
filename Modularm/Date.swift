//
//  Date.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum DateDisplayType: Int16 {
   case US, EU, NoDate
}

@objc(Date)
class Date: NSManagedObject
{
   @NSManaged var displayTypeValue: Int16
   @NSManaged var alarm: Alarm
   
   var displayType: DateDisplayType {
      get {
         return DateDisplayType(rawValue: self.displayTypeValue)!
      }
      set {
         self.displayTypeValue = newValue.rawValue
      }
   }
   
   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      self.displayType = .US
   }
}

extension Date: AlarmOptionModelProtocol
{
   func humanReadableString() -> String
   {
      return "DATE"
   }
}
