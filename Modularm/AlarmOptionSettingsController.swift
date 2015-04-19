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
   @IBOutlet weak var iconImageView: UIImageView!
   var optionButton: AlarmOptionButton?

   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.iconImageView.tintColor = UIColor.lipstickRedColor()
   }

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      if let button = self.optionButton
      {
         self.iconImageView.image = button.deactivatedImage?.templateImage
      }
   }

   @IBAction func dismissSelf()
   {
      // temporary
      self.optionButton?.toggleActivation()
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
      self.optionButton = sender
   }
}
