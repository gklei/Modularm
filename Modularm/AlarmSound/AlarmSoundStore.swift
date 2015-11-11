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
   var alarmSound:String { get }       //Sound name in main bundle
}

// MARK: - Extend PAlarmSound to able to preview play (MusicSupport)
extension PAlarmSound{
   var musicType:AlarmMusicType{
      return .iPodLibrary
   }
}

protocol PAlarmSoundStore {
   func fetchAlarmSounds() -> [PAlarmSound]
}

class AlarmSoundStore:PAlarmSoundStore{
   static let sharedInstance:PAlarmSoundStore = AlarmSoundStore()
   let alarms:[PAlarmSound] = {
      let array:[PAlarmSound] =
      [AlarmSound("AlarmSound.caf"),
         AlarmSound("ElectroAlarmPrint.caf"),
         AlarmSound("HappyDay.caf"),
         AlarmSound("HipHopAlarm.caf"),
         AlarmSound("HurryUpWakeUp.caf"),
         AlarmSound("SimpleAlarm.caf")]
      return array
   }()
   
   func fetchAlarmSounds() -> [PAlarmSound]{
      return alarms
   }
   
   private struct AlarmSound:PAlarmSound{
      var alarmSound:String
      var name:String
      init(_ fileName:String, _ name:String? = nil){
         alarmSound = fileName
         self.name = name ?? (fileName as NSString).stringByDeletingPathExtension
      }
      
      var url:NSURL{
         return NSBundle.mainBundle().URLForResource(alarmSound, withExtension: nil) ?? NSURL()
      }
   }
}