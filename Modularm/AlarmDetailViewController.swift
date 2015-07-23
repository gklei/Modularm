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
   @IBOutlet weak var editCancelButton: UIButton!
   
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
   
   override func viewWillDisappear(animated: Bool)
   {
      super.viewWillDisappear(animated)
      self.navigationController?.navigationBarHidden = false
   }
   
   // MARK: - Private
   private func updateUIForFiringState()
   {
      var editCancelButtonTitle = ""
      var editCancelButtonImage = UIImage(named: "icn-x")
      var editCancelButtonBackgroundColor = UIColor.blackColor()
      
      if self.alarmIsFiring
      {
         self.navigationController?.navigationBarHidden = true
         self.tearDownTestButton()
      }
      else
      {
         editCancelButtonTitle = "edit"
         editCancelButtonImage = nil
         editCancelButtonBackgroundColor = UIColor.clearColor()
         self.navigationController?.navigationBarHidden = false
         self.setupTestButton()
      }
      
      self.editCancelButton.setTitle(editCancelButtonTitle, forState: .Normal)
      self.editCancelButton.setBackgroundImage(editCancelButtonImage, forState: .Normal)
      self.editCancelButton.backgroundColor = editCancelButtonBackgroundColor
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
      let barButtonItem = UIBarButtonItem(title: "test", style: .Plain, target: nil, action: nil)
      barButtonItem.tintColor = UIColor.lipstickRedColor()
      
      let font = UIFont.systemFontOfSize(20)
      let attributes = [NSFontAttributeName : font]
      barButtonItem.setTitleTextAttributes(attributes, forState: .Normal)
      barButtonItem.setTitlePositionAdjustment(UIOffset(horizontal: -12, vertical: 0), forBarMetrics: .Default)
      
      self.navigationItem.rightBarButtonItem = barButtonItem
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
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?, isFiring: Bool)
   {
      println("alarm to show! \(alarm)")
      self.alarm = alarm
      self.alarmIsFiring = isFiring
   }
   
   // MARK: - IBActions
   @IBAction func editCancelButtonPressed()
   {
      if !self.alarmIsFiring
      {
         let configurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
         if let alarm = self.alarm
         {
            configurationController.configureWithAlarm(alarm)
         }
         self.navigationController?.pushViewController(configurationController, animated: true)
         
         self.updateBackBarButtonItemWithTitle("Back")
      }
      else
      {
         self.alarm?.active = false
         self.navigationController?.popToRootViewControllerAnimated(true)
      }
   }
}
