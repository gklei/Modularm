//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionSettingsController: UIViewController
{
   override func viewDidLoad()
   {
      super.viewDidLoad()
   }

   @IBAction func dismissSelf()
   {
      self.navigationController?.popViewControllerAnimated(true)
   }

   func configureWithAlarmOption(option: AlarmOption, sender: AlarmOptionButton)
   {
      switch (option)
      {
      case .Countdown:
         break
      case .Date:
         break
      case .Message:
         break
      case .Music:
         break
      case .Repeat:
         break
      case .Snooze:
         break
      case .Sound:
         break
      case .Weather:
         break

      default:
         break
      }
   }
}
