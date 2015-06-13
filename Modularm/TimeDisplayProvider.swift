//
//  TimeDisplayProvider.swift
//  Modularm
//
//  Created by Klein, Greg on 6/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

struct TimeDisplayProvider
{
   static func textForHourValue(value: Int) -> String
   {
      var hourInt = (value + 12) % 12
      hourInt = hourInt == 0 ? 12 : hourInt
      return hourInt <= 9 ? "0\(hourInt)" : "\(hourInt)"
   }
   
   static func textForMinuteValue(value: Int) -> String
   {
      return value <= 9 ? "0\(value)" : "\(value)"
   }
}
