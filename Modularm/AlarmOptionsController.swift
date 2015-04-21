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
      case "configureCountdown":
         option = .Countdown
         break
         
      default:
         option = .Unknown
         break
      }

      var optionButton = sender as! AlarmOptionButton
      optionButton.option = option
      optionSettingsController.configureWithOptionButton(optionButton)
   }
}
