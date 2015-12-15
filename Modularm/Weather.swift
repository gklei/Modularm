//
//  Weather.swift
//  Modularm
//
//  Created by Klein, Greg on 5/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreData

enum WeatherDisplayType: Int16 {
   case US, EU, NoTemperature
}

@objc(Weather)
class Weather: NSManagedObject
{
   @NSManaged var alarm: Alarm
   @NSManaged var readableTextSummary: String
   @NSManaged var fahrenheitTemperature: Double
   @NSManaged var weatherDescription: String
   
   var weatherSummaryType: WeatherSummaryType {
      return WeatherSummaryType(readableTextSummary)
   }
   
   var celciusTemperature: Double {
      return (fahrenheitTemperature - 32) * 5 / 9
   }

   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      readableTextSummary = "clear-night"
   }
}

extension Weather: AlarmOptionModelProtocol
{
   func humanReadableString() -> String
   {
      return "WEATHER"
   }
}