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
let kDateDisplaySettingsKey = "DateDisplaySettingsKey"
let kWeatherDisplaySettingsKey = "WeatherDisplaySettingsKey"

enum DisplayMode: Int {
   case Analog, Digital
}

enum TimeFormat: Int {
   case Standard, Military
}

struct AppSettingsManager
{
   static var displayMode: DisplayMode {
      let displayValue = NSUserDefaults.standardUserDefaults().integerForKey(kAlarmDisplaySettingsKey) as Int
      return DisplayMode(rawValue: displayValue)!
   }
   
   static var timeFormat: TimeFormat {
      let formatValue = NSUserDefaults.standardUserDefaults().integerForKey(kTimeFormatSettingsKey) as Int
      return TimeFormat(rawValue: formatValue)!
   }
   
   static var dateDisplay: DateDisplayType {
      let dateDisplayValue = NSUserDefaults.standardUserDefaults().integerForKey(kDateDisplaySettingsKey) as Int
      return DateDisplayType(rawValue: Int16(dateDisplayValue))!
   }
   
   static var weatherDisplay: WeatherDisplayType {
      let weatherDisplayValue = NSUserDefaults.standardUserDefaults().integerForKey(kWeatherDisplaySettingsKey) as Int
      return WeatherDisplayType(rawValue: Int16(weatherDisplayValue))!
   }

   static func setDisplayMode(mode: DisplayMode)
   {
      NSUserDefaults.standardUserDefaults().setInteger(mode.rawValue, forKey: kAlarmDisplaySettingsKey)
   }
   
   static func setTimeFormat(format: TimeFormat)
   {
      NSUserDefaults.standardUserDefaults().setInteger(format.rawValue, forKey: kTimeFormatSettingsKey)
   }
   
   static func setDateDisplay(type: DateDisplayType)
   {
      NSUserDefaults.standardUserDefaults().setInteger(Int(type.rawValue), forKey: kDateDisplaySettingsKey)
   }
   
   static func setWeatherDisplay(type: WeatherDisplayType)
   {
      NSUserDefaults.standardUserDefaults().setInteger(Int(type.rawValue), forKey: kWeatherDisplaySettingsKey)
   }
}

