//
//  AlarmViewModel.swift
//  Modularm
//
//  Created by Klein, Greg on 5/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

struct TimelineCellAlarmViewModel
{
   var alarm: Alarm
   
   private lazy var dateFormatter: NSDateFormatter =
   {
      let formatter = NSDateFormatter()
      return formatter
      }()
   
   var innerContentViewBackgroundColor: UIColor {
      get {
         return self.alarm.active ? UIColor(white: 0.09, alpha: 1) : UIColor.normalOptionButtonColor()
      }
   }
   
   var separatorViewBackgroundColor: UIColor {
      get {
         return self.alarm.active ? UIColor(white: 0.13, alpha: 1) : UIColor(white: 0.88, alpha: 1)
      }
   }
   
   var attributedLabelText: NSAttributedString {
      mutating get {
         self.dateFormatter.dateFormat = "hh:mm"
         var prettyAlarmDate = self.dateFormatter.stringFromDate(self.alarm.fireDate)
         
         self.dateFormatter.dateFormat = "aa"
         var amOrPm = dateFormatter.stringFromDate(self.alarm.fireDate).lowercaseString
         prettyAlarmDate += " \(amOrPm)"
         
         var alarmMessage = ""
         if self.alarm.message != nil
         {
            alarmMessage = "  \(self.alarm.message!.text)"
         }
         else
         {
            self.dateFormatter.dateFormat = "EEEE"
            alarmMessage = "  \(dateFormatter.stringFromDate(self.alarm.fireDate))"
         }
         
         let textColor = self.alarm.active ? UIColor.whiteColor() : UIColor.grayColor()
         var attributedText = NSAttributedString(boldText: prettyAlarmDate, text: alarmMessage, color: textColor)
         if self.alarm.active == false
         {
            attributedText = NSAttributedString(lightText: "\(prettyAlarmDate)\(alarmMessage)", color: textColor)
         }
         
         return attributedText
      }
   }
   
   init(alarm: Alarm)
   {
      self.alarm = alarm
   }
}
