//
//  PVSAlarm.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Alarm)
class Alarm: NSManagedObject
{
    @NSManaged var date: NSTimeInterval
    @NSManaged var message: String
   
   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      
      self.date = NSDate().timeIntervalSince1970
      self.message = ""
   }
}
