//
//  TimeController.swift
//  Modularm
//
//  Created by Klein, Greg on 5/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol TimeControllerDelegate
{
   func settingTimeBegan()
   func settingTimeEnded()
}

class TimeController: UIViewController
{
   @IBOutlet weak var setTimeButton: UIButton!
   @IBOutlet weak var timePicker: UIDatePicker!
   
   var alarm: Alarm?
   var timeControllerDelegate: TimeControllerDelegate?
   
   private var settingTime = false
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
   }
   
   func configureWithAlarm(alarm: Alarm?, delegate: TimeControllerDelegate)
   {
      self.alarm = alarm
      self.timeControllerDelegate = delegate
   }
   
   func updateSetTimeButtonTitle(title: String)
   {
      UIView.setAnimationsEnabled(false)
      self.setTimeButton.setTitle(title, forState: .Normal)
      self.setTimeButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true);
   }
   
   @IBAction func setTimeButtonPressed()
   {
      if self.settingTime == false
      {
         self.updateSetTimeButtonTitle("end setting time")
         self.timePicker.userInteractionEnabled = true
         self.timeControllerDelegate?.settingTimeBegan()
      }
      else
      {
         self.updateSetTimeButtonTitle("start setting time")
         self.timePicker.userInteractionEnabled = false
         self.timeControllerDelegate?.settingTimeEnded()
         
         self.logTimePickerAndCurrentTime()
      }
      self.settingTime = !self.settingTime
   }
   
   private func startSettingTime()
   {
   }
   
   private func logTimePickerAndCurrentTime()
   {
      let comp = NSCalendar.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: self.timePicker.date)
      let pickerHour = comp.hour
      let pickerMinute = comp.minute
      
      let currentComp = NSCalendar.currentCalendar().components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: NSDate())
      let currentHour = currentComp.hour
      let currentMinute = currentComp.minute
      
      println("current hour: \(currentHour) minute: \(currentMinute)")
      println("time picker hour: \(pickerHour), minute: \(pickerMinute)")
   }
}
