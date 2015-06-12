//
//  TimelineHeaderView.swift
//  Modularm
//
//  Created by Gregory Klein on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimelineHeaderView: UICollectionReusableView
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var amOrPmLabel: UILabel!
   
   var alarm: Alarm?
   weak var timelineController: TimelineController?
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      
      var hour = alarm.fireDate.hour
      if hour > 12 {
         hour -= 12
      }
      
      hour = (hour == 0) ? 12 : hour
      let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
      
      let minute = alarm.fireDate.minute
      let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "aa"
      let amOrPmString = dateFormatter.stringFromDate(alarm.fireDate).lowercaseString
      
      self.hourLabel.text = hourString
      self.minuteLabel.text = minuteString
      self.amOrPmLabel.text = amOrPmString
   }
   
   @IBAction func editButtonPressed()
   {
      if let controller = self.timelineController, alarm = self.alarm
      {
         controller.openSettingsForAlarm(alarm)
      }
   }
}
