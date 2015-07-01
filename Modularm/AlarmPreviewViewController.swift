//
//  AlarmPreviewViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmPreviewViewController: UIViewController
{
   // MARK: - Properties
   @IBOutlet weak var alarmTimeView: DigitalTimeView!
   @IBOutlet weak var informativeTimeLabel: UILabel!
   @IBOutlet weak var previewAuxiliaryView: UIView!
   
   private weak var alarm: Alarm?
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.clearColor()
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.updateHourAndMinuteLabelsWithAlarm(self.alarm)
      self.updateInformativeTimeLabel()
   }

   // MARK: Public
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
   }
   
   // MARK: - Private
   private func updateHourAndMinuteLabelsWithAlarm(alarm: Alarm?)
   {
      if let alarm = self.alarm
      {
         self.alarmTimeView.updateTimeWithAlarm(alarm)
      }
   }
   
   func updateLabelsWithHour(hour: Int, minute: Int)
   {
      self.alarmTimeView.updateTimeWithHour(hour, minute: minute)
   }
   
   func updateInformativeTimeLabel()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         self.informativeTimeLabel.text = AlarmCountdownUtility.countdownTextForAlarmDate(alarmDate)
      }
   }
}
