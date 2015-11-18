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
   
   var alarmMusic: PAlarmMusic?
   {
      var foundMusic: PAlarmMusic?
      for sound in AlarmSoundStore.sharedInstance.fetchAlarmSounds()
      {
         if let path = sound.url.path where path == self.soundURL {
            foundMusic = sound
            break
         }
      }
      return foundMusic
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
