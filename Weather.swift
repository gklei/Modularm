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
   @NSManaged var displayTypeValue: Int16
   @NSManaged var backgroundPhotoOn: Bool
   @NSManaged var autoLocationOn: Bool
   @NSManaged var alarm: Alarm
   
   var displayType: WeatherDisplayType {
      get {
         return WeatherDisplayType(rawValue: self.displayTypeValue)!
      }
      set {
         self.displayTypeValue = newValue.rawValue
      }
   }

   override func awakeFromInsert()
   {
      super.awakeFromInsert()
      
      self.displayType = .US
      self.backgroundPhotoOn = false
      self.autoLocationOn = false
   }
}
