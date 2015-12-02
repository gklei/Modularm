//
//  AlarmOptionsController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol AlarmOptionsControllerDelegate
{
   func didShowSettingsForOption()
   func didDismissSettingsForOption()
   func optionPreviewAuxiliaryView() -> UIView?
}

class AlarmOptionsViewController: UIViewController
{
   var optionsControllerDelegate: AlarmOptionsControllerDelegate?
   private var alarm: Alarm?
   private var vcForPresenting: UIViewController?
   private var _alarmMusicPlayer: PAlarmMusicPlayer?

   @IBOutlet weak var snoozeButton: AlarmOptionButton!
   @IBOutlet weak var weatherButton: AlarmOptionButton!
   @IBOutlet weak var soundButton: AlarmOptionButton!
   @IBOutlet weak var repeatButton: AlarmOptionButton!
   @IBOutlet weak var messageButton: AlarmOptionButton!
   @IBOutlet weak var messageButtonTextLabel: UILabel!
   
   // MARK: - Lifecycle
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.updateButtonsWithAlarm(self.alarm)

      // temporary
      self.optionsControllerDelegate?.didDismissSettingsForOption()
      
      if let auxView = self.optionsControllerDelegate?.optionPreviewAuxiliaryView()
      {
         for subview in auxView.subviews
         {
            subview.removeFromSuperview()
         }
      }
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
      case "configureSound":
         option = .Sound
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

      let auxView = self.optionsControllerDelegate?.optionPreviewAuxiliaryView()
      optionSettingsController.configureWithAlarm(self.alarm, option: option, auxiliaryView: auxView)
      optionSettingsController.updateViewControllerForPresenting(self.vcForPresenting)
      
      self.optionsControllerDelegate?.didShowSettingsForOption()
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?, vcForPresenting: UIViewController?)
   {
      self.alarm = alarm
      self.vcForPresenting = vcForPresenting
   }

   func returnToMainOptions()
   {
      self.navigationController?.popToRootViewControllerAnimated(true)
   }
   
   // MARK: - IBActions
   @IBAction func weatherButtonPressed(sender: AnyObject)
   {
      if let alarm = self.alarm {
         if alarm.weather != nil {
            alarm.deleteOption(.Weather)
         }
         else {
            alarm.weather = CoreDataStack.newModelWithOption(.Weather) as? Weather
         }
      }
      updateButtonsWithAlarm(self.alarm)
   }
   
   @IBAction func resetAlarm()
   {
      for option in AlarmOption.validOptions
      {
         if (option != .Sound) {
            self.alarm?.deleteOption(option)
         }
         self.alarm?.sound?.gradual = false
      }
      self.updateButtonsWithAlarm(self.alarm)
   }

   // MARK: - Private
   private func updateButtonsWithAlarm(alarm: Alarm?)
   {
      if let alarmModel = alarm
      {
         self.snoozeButton.activated = alarmModel.snooze != nil
         self.weatherButton.activated = alarmModel.weather != nil
         self.repeatButton.activated = alarmModel.repeatModel != nil
         self.messageButton.activated = alarmModel.message != nil
         self.messageButtonTextLabel.text = alarmModel.message?.text
         
         // the sound button should always be activated because the sound model should never be nil
         self.soundButton.activated = alarmModel.sound != nil
      }
   }
}
