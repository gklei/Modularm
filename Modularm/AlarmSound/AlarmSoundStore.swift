//
//  AlarmSoundStore.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - PAlarmSound
protocol PAlarmSound:PAlarmMusic{
   var nameInMainBundle: String { get }       //Sound name in main bundle
   var name: String { get }
}

// MARK: - Extend PAlarmSound to able to preview play (MusicSupport)
extension PAlarmSound{
   var musicType:AlarmMusicType {
      return .iPodLibrary
   }
}

protocol PAlarmSoundStore {
   func fetchAlarmSounds() -> [PAlarmSound]
}

class AlarmSoundStore:PAlarmSoundStore {
   static let sharedInstance:PAlarmSoundStore = AlarmSoundStore()
   let alarms:[PAlarmSound] = {
      let array:[PAlarmSound] = [
         AlarmSound("AlarmSound.caf", "Xylophone Anthem"),
         AlarmSound("ElectroAlarmPrint.caf", "EDM Style"),
         AlarmSound("HappyDay.caf", "Happy Days"),
         AlarmSound("HipHopAlarm.caf", "Hip Hop Bop"),
         AlarmSound("HurryUpWakeUp.caf", "Hurry up, Wake up!"),
         AlarmSound("SimpleAlarm.caf", "Lullaby Tune"),
         AlarmSound("Gongs.caf", "Morning Monk"),
         AlarmSound("Sly.caf", "Sesame Street"),
         AlarmSound("ThumbsUp.caf", "Jungle Jam")
      ]
      return array
   }()
   
   func fetchAlarmSounds() -> [PAlarmSound]{
      return alarms
   }
   
   private struct AlarmSound:PAlarmSound
   {
      var nameInMainBundle:String
      var name:String
      
      init(_ fileName: String, _ name: String? = nil)
      {
         nameInMainBundle = fileName
         self.name = name ?? (fileName as NSString).stringByDeletingPathExtension
      }
      
      var url:NSURL {
         return NSBundle.mainBundle().URLForResource(nameInMainBundle, withExtension: nil) ?? NSURL()
      }
   }
}