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
   @NSManaged var soundURL: String
   @NSManaged var gradual: Bool
   @NSManaged var alarm: Alarm
   
   var alarmSound: PAlarmSound?
   {
      let soundName = NSURL(string: soundURL)?.lastPathComponent!
      var found: PAlarmSound?
      for sound in AlarmSoundStore.sharedInstance.fetchAlarmSounds()
      {
         if soundName == sound.nameInMainBundle {
            found = sound
            break
         }
      }
      return found
   }
   
   override func awakeFromInsert()
   {
      self.soundURL = AlarmSoundStore.sharedInstance.fetchAlarmSounds()[0].url.path!
   }
}

extension Sound: AlarmOptionModelProtocol
{
   func humanReadableString() -> String
   {
      return "SOUND"
   }
}
