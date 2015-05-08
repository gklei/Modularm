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
   
   // MARK: Lifecycle -
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      let optionSettingsController = segue.destinationViewController as! AlarmOptionSettingsControllerProtocol
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
      let optionButton = sender as! AlarmOptionButton
      if optionButton.activated
      {
         optionButton.deactivate()
      }
      else
      {
         optionButton.activate()
      }
   }
}
