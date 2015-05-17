//
//  NSCalendar+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 5/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import UIKit

extension NSCalendar
{
   static var currentHour: Int {
      get {
         return self.currentCalendar().components((.CalendarUnitHour | .CalendarUnitHour), fromDate: NSDate()).hour
      }
   }
   
   static var currentMinute: Int {
      get {
         return self.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: NSDate()).minute
      }
   }
}

extension NSDate
{
   var hour: Int {
      return NSCalendar.currentCalendar().components((.CalendarUnitHour), fromDate: self).hour
   }
   
   var minute: Int {
      return NSCalendar.currentCalendar().components((.CalendarUnitMinute), fromDate: self).minute
   }
   
   var day: Int {
      return NSCalendar.currentCalendar().components((.CalendarUnitDay), fromDate: self).day
   }
   
   func logHourAndMinute()
   {
      println("hour: \(self.hour) minute: \(self.minute)")
   }
}

extension UIDatePicker
{
   var alarmDate: NSDate {
      get {
         let date = self.date
         let timePickerHour = date.hour
         let timePickerMinute = date.minute
         
         let currentDate = NSDate()
         let currentHour = currentDate.hour
         let currentMinute = currentDate.minute
         
         var secondsToAdd = date.timeIntervalSinceNow
         if currentDate.compare(date) != .OrderedAscending
         {
            secondsToAdd += (24 * 60 * 60)
         }
         
         if date.hour >= currentDate.hour && date.minute > currentDate.minute && date.day > currentDate.day
         {
            secondsToAdd -= (24 * 60 * 60)
         }
         
         return NSDate(timeIntervalSinceNow: secondsToAdd)
      }
   }
}
