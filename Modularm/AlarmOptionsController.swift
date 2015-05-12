//
//  AlarmOptionsController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionsController: UIViewController
{
   private var alarm: Alarm?

   @IBOutlet weak var snoozeButton: AlarmOptionButton!
   @IBOutlet weak var weatherButton: AlarmOptionButton!
   @IBOutlet weak var soundButton: AlarmOptionButton!
   @IBOutlet weak var dateButton: AlarmOptionButton!
   @IBOutlet weak var musicButton: AlarmOptionButton!
   @IBOutlet weak var repeatButton: AlarmOptionButton!
   @IBOutlet weak var messageButton: AlarmOptionButton!
   @IBOutlet weak var countdownButton: AlarmOptionButton!
   
   // MARK: - Lifecycle
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.setupButtonsWithAlarm(self.alarm)
   }

   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      let optionSettingsController = segue.destinationViewController as! OptionSettingsControllerBase
      var option: AlarmOption

      switch (segue.identifier!)
      {
      case "configureSnooze":
         option = .Snooze
         break
      case "configureWeather":
         option = .Weather
         break
      case "configureSound":
         option = .Sound
         break
      case "configureDate":
         option = .Date
         break
      case "configureMusic":
         option = .Music
         break
      case "configureRepeat":
         option = .Repeat
         break
      case "configureMessage":
         option = .Message
         break
         
      default:
         option = .Unknown
         break
      }

      optionSettingsController.configureWithAlarm(self.alarm, option: option)
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   // MARK: - IBActions
   @IBAction func toggleCountdown(sender: AnyObject)
   {
   }

   // MARK: - Private
   private func setupButtonsWithAlarm(alarm: Alarm?)
   {
      if let alarmModel = alarm
      {
         self.snoozeButton.activated = alarmModel.snooze != nil
         self.countdownButton.activated = alarmModel.countdown != nil
         self.weatherButton.activated = alarmModel.weather != nil
         self.soundButton.activated = alarmModel.sound != nil
         self.dateButton.activated = alarmModel.date != nil
         self.repeatButton.activated = alarmModel.repeat != nil
         self.messageButton.activated = alarmModel.message != nil
         self.countdownButton.activated = alarmModel.countdown != nil
      }
   }
}
