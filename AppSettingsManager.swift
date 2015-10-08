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

enum DisplayMode {
   case Analog, Digital
}

enum TimeFormat {
   case Standard, Military
}

struct AppSettingsManager
{
   static var displayMode: DisplayMode {
      get {
         return .Digital
      }
   }
   
   static var timeFormat: TimeFormat {
      get {
         return .Standard
      }
   }
}

