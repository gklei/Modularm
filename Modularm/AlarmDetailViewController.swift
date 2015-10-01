//
//  AlarmViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/28/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmDetailViewController: UIViewController
{
   private var alarm: Alarm?
   
   @IBOutlet weak var alarmMessageLabel: UILabel!
   @IBOutlet weak var alarmTimeView: DigitalTimeView!
   @IBOutlet weak var editButton: UIButton!
   @IBOutlet weak var cancelButton: UIButton!
   
   private var alarmIsFiring = false
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.setupTitle()
      self.updateTimeLabels()
      self.updateUIForFiringState()
   }
   
   // MARK: - Private
   private func updateUIForFiringState()
   {
      if self.alarmIsFiring
      {
         self.editButton.hidden = true
         self.cancelButton.hidden = false
         self.navigationController?.navigationBarHidden = true
         self.tearDownTestButton()
      }
      else
      {
         self.editButton.hidden = false
         self.cancelButton.hidden = true
         self.navigationController?.navigationBarHidden = false
         self.setupTestButton()
      }
   }
   
   private func setupTitle()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         let countdownTime = AlarmCountdownUtility.timeUntilAlarmHour(alarmDate.hour, minute: alarmDate.minute)
         self.title = "Alarm in \(countdownTime.hour)h \(countdownTime.minute)m"
      }
   }
   
   private func setupTestButton()
   {
      let color = UIColor.lipstickRedColor()
      self.navigationItem.rightBarButtonItem = UIBarButtonItem.rightBarButtonItemWithTitle("test", color: color)
   }
   
   private func tearDownTestButton()
   {
      self.navigationItem.rightBarButtonItem = nil
   }

   private func updateTimeLabels()
   {
      if let alarm = self.alarm {
         self.alarmTimeView.updateTimeWithAlarm(alarm)
      }
      if let message = self.alarm?.message?.text
      {
         self.alarmMessageLabel.text = message
      }
      else
      {
         if let soundName = self.alarm?.sound?.basicSoundURL
         {
            self.alarmMessageLabel.text = "Alarm sound: \(soundName)"
         }
         else
         {
            self.alarmMessageLabel.text = "No sound is set!"
         }
      }
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle
   {
      return .LightContent
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?, isFiring: Bool)
   {
      self.alarm = alarm
      self.alarmIsFiring = isFiring
   }
   
   // MARK: - IBActions
   @IBAction func editButtonPressed()
   {
      let configurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
      if let alarm = self.alarm
      {
         configurationController.configureWithAlarm(alarm)
      }
      self.navigationController?.pushViewController(configurationController, animated: true)
      self.updateBackBarButtonItemWithTitle("Back")
   }
   
   @IBAction func cancelButtonPressed()
   {
      self.alarm?.active = false
      self.navigationController?.popToRootViewControllerAnimated(true)
   }
}
