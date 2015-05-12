//
//  UIDatePicker+Additions.swift
//  Modularm
//
//  Created by Klein, Greg on 5/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import CoreFoundation
import Foundation
import UIKit

extension NSCalendar
{
   static func logHourAndMinuteWithDate(date: NSDate)
   {
      let comp = self.currentCalendar().components((NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute), fromDate: date)
      let pickerHour = comp.hour
      let pickerMinute = comp.minute
      
      println("hour: \(pickerHour) minute: \(pickerMinute)")
   }
}
