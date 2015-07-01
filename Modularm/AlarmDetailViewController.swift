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
   private let testButton = UIButton.buttonWithTitle("test", color: UIColor.lipstickRedColor())
   
   @IBOutlet weak var alarmMessageLabel: UILabel!
   @IBOutlet weak var alarmTimeView: DigitalTimeView!
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.setupTestButton()
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.setupTitle()
      self.setupTimeLabels()
   }
   
   // MARK: - Private
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
   
   private func setupTimeLabels()
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
         let soundName = self.alarm!.sound!.basicSoundURL
         self.alarmMessageLabel.text = "Alarm sound: \(soundName)"
      }
   }
   
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   // MARK: - Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   // MARK: - IBActions
   @IBAction func editButtonPressed()
   {
      if let configurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as? AlarmConfigurationController
      {
         configurationController.configureWithAlarm(self.alarm!)
         self.navigationController?.pushViewController(configurationController, animated: true)
         
         self.updateBackBarButtonItemWithTitle("Back")
      }
   }
}
