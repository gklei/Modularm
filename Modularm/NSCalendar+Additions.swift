//
//  NSCalendar+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 5/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

extension NSCalendar
{
   static func logHourAndMinuteWithDate(date: NSDate)
   {
      let comp = self.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: date)
      let pickerHour = comp.hour
      let pickerMinute = comp.minute
      
      println("hour: \(pickerHour) minute: \(pickerMinute)")
   }
}
