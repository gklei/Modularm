//
//  NSDateExtension.swift
//  Modularm
//
//  Created by Alex Hong on 11/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - NSDate Extension for alarm utility
extension NSDate
{
   func updateHour(hour:Int, minute:Int) -> NSDate
   {
      let calendar = NSCalendar.currentCalendar()
      let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: self)
      components.hour = hour
      components.minute = minute
      components.second = 0
      return calendar.dateFromComponents(components)!
   }
   
   func dayOfWeek() -> Int
   {
      let calendar = NSCalendar.currentCalendar()
      return calendar.components([.Weekday], fromDate: self).weekday
   }
   
   func nextDay() -> NSDate
   {
      return self.dateByAddingTimeInterval(24 * 60 * 60)
   }
}

// Comparison operators for NSDate

func <(l: NSDate, r: NSDate) -> Bool {
   return l.compare(r) == .OrderedAscending
}

func >(l: NSDate, r: NSDate) -> Bool {
   return l.compare(r) == .OrderedDescending
}

func ==(l: NSDate, r: NSDate) -> Bool {
   return l.compare(r) == .OrderedSame
}

func <=(l: NSDate, r: NSDate) -> Bool {
   let result = l.compare(r)
   return result == .OrderedAscending || result == .OrderedSame
}

func >=(l: NSDate, r: NSDate) -> Bool {
   let result = l.compare(r)
   return result == .OrderedDescending || result == .OrderedSame
}
