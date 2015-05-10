//
//  Sound.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

@objc(Sound)
class Sound: NSManagedObject
{
   @NSManaged var basicSoundURL: String
   @NSManaged var shouldVibrate: Bool
   @NSManaged var alarm: Alarm
   
   override func awakeFromInsert()
   {
      // VERY TEMPORARY!
      self.basicSoundURL = "Basic"
   }
}
