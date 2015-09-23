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
         return self.currentCalendar().components(([.Hour, .Hour]), fromDate: NSDate()).hour
      }
   }
   
   static var currentMinute: Int {
      get {
         return self.currentCalendar().components(([.Hour, .Minute]), fromDate: NSDate()).minute
      }
   }
}

extension NSDate
{
   var hour: Int {
      return NSCalendar.currentCalendar().components((.Hour), fromDate: self).hour
   }
   
   var minute: Int {
      return NSCalendar.currentCalendar().components((.Minute), fromDate: self).minute
   }
   
   var day: Int {
      return NSCalendar.currentCalendar().components((.Day), fromDate: self).day
   }
   
   func logHourAndMinute()
   {
      print("hour: \(self.hour) minute: \(self.minute)")
   }
   
   func prettyDateString() -> String
   {
      let formatter = NSDateFormatter()
      formatter.dateStyle = NSDateFormatterStyle.LongStyle
      formatter.timeStyle = .MediumStyle
      
      return formatter.stringFromDate(self)
   }
   
   class func alarmDateWithHour(hour: Int, minute: Int) -> NSDate
   {
      let currentDate = NSDate()
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components(([.Day, .Year, .Month]), fromDate: NSDate())
      
      components.hour = hour
      components.minute = minute
      components.second = 0
      
      let date = calendar.dateFromComponents(components)!
      var secondsToAdd = date.timeIntervalSinceNow
      if currentDate.compare(date) != .OrderedAscending
      {
         secondsToAdd += (24 * 60 * 60)
      }
      
      if date.hour == currentDate.hour && date.minute > currentDate.minute && date.day > currentDate.day || (date.hour > currentDate.hour && date.day > currentDate.day)
      {
         secondsToAdd -= (24 * 60 * 60)
      }
      
      return NSDate(timeIntervalSinceNow: secondsToAdd)
   }
}
