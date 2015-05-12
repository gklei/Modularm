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
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      if let alarmModel = self.alarm
      {
         self.timePicker.setDate(alarmModel.fireDate, animated: false)
      }
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
      self.updateUIForSettingTime(self.settingTime)
      self.settingTime = !self.settingTime
   }
   
   private func updateUIForSettingTime(setting: Bool)
   {
      if setting == false
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
         
         self.alarm?.fireDate = self.timePicker.alarmDate
         self.logDateInformation()
      }
   }
   
   private func logDateInformation()
   {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "YYYY MMM d, hh:mm aa"
      
      let prettyAlarmDate = dateFormatter.stringFromDate(self.timePicker.alarmDate)
      println("Alarm date is set for: \(prettyAlarmDate)")
   }
}
