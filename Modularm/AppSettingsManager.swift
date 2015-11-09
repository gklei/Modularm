//
//  AppSettingsManager.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

let kAlarmDisplaySettingsKey = "AlarmDisplaySettingsKey"
let kTimeFormatSettingsKey = "TimeFormatSettingsKey"

enum DisplayMode: Int {
   case Analog, Digital
}

enum TimeFormat: Int {
   case Standard, Military
}

struct AppSettingsManager
{
   static var displayMode: DisplayMode {
      get {
         let displayValue = NSUserDefaults.standardUserDefaults().integerForKey(kAlarmDisplaySettingsKey) as Int
         return DisplayMode(rawValue: displayValue)!
      }
   }
   
   static var timeFormat: TimeFormat {
      get {
         let formatValue = NSUserDefaults.standardUserDefaults().integerForKey(kTimeFormatSettingsKey) as Int
         return TimeFormat(rawValue: formatValue)!
      }
   }

   static func setDisplayMode(mode: DisplayMode)
   {
      NSUserDefaults.standardUserDefaults().setInteger(mode.rawValue, forKey: kAlarmDisplaySettingsKey)
   }
   
   static func setTimeFormat(format: TimeFormat)
   {
      NSUserDefaults.standardUserDefaults().setInteger(format.rawValue, forKey: kTimeFormatSettingsKey)
   }
}

