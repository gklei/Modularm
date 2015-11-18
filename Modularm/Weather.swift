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

   override func awakeFromInsert()
   {
      super.awakeFromInsert()
   }
}

extension Weather: AlarmOptionModelProtocol
{
   func humanReadableString() -> String
   {
      return "WEATHER"
   }
}