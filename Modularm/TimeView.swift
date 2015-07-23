//
//  TimeView.swift
//  Modularm
//
//  Created by Klein, Greg on 7/4/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimeView: UIView
{
   internal var time: (hour: Int, minute: Int) = (0, 0)
   func updateTimeWithAlarm(alarm: Alarm)
   {
      self.time = (alarm.fireDate.hour, alarm.fireDate.minute)
   }
   
   func updateTimeWithHour(hour: Int, minute: Int)
   {
      self.time = (hour, minute)
   }
}
