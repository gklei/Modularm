//
//  AlarmPreviewViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmPreviewViewController: UIViewController
{
   // MARK: - Properties
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var informativeTimeLabel: UILabel!
   
   private weak var alarm: Alarm?
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.clearColor()
      self.updateHourAndMinuteLabelsWithAlarm(self.alarm)
      self.updateInformativeTimeLabel()
   }

   // MARK: Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   // MARK: - Private
   private func updateHourAndMinuteLabelsWithAlarm(alarm: Alarm?)
   {
      if let date = self.alarm?.fireDate
      {
         self.updateLabelsWithHour(date.hour, minute: date.minute)
      }
   }
   
   func updateLabelsWithHour(hour: Int, minute: Int)
   {
      var hourInt = (hour + 12) % 12
      hourInt = hourInt == 0 ? 12 : hourInt
      self.hourLabel.text = hourInt <= 9 ? "0\(hourInt)" : "\(hourInt)"
      self.minuteLabel.text = minute <= 9 ? "0\(minute)" : "\(minute)"
   }
   
   func updateInformativeTimeLabel()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         let currentDate = NSDate()
         
         let currentHourMinute = (currentDate.hour, currentDate.minute)
         let dateHourMinute = (alarmDate.hour, alarmDate.minute)
         
         var hour = dateHourMinute.0 - currentHourMinute.0
         if dateHourMinute.0 < currentHourMinute.0 {
            hour += 24
         }
         
         var minute = dateHourMinute.1 - currentHourMinute.1
         if dateHourMinute.1 < currentHourMinute.1 {
            minute += 60
            hour -= 1
         }
         
         if hour == 0 && minute == 0 {
            hour = 24
         }
         
         if hour < 0 {
            hour = 23
         }
         
         self.informativeTimeLabel.text = "\(hour) hours and \(minute) minutes"
      }
   }
}
