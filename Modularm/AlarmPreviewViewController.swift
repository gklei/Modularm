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
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
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
      if let date = self.alarm?.fireDate
      {
         self.updateLabelsWithHour(date.hour, minute: date.minute)
      }
   }
   
   func updateLabelsWithHour(hour: Int, minute: Int)
   {
      self.hourLabel.text = TimeDisplayProvider.textForHourValue(hour)
      self.minuteLabel.text = minute <= 9 ? "0\(minute)" : "\(minute)"
   }
   
   func updateInformativeTimeLabel()
   {
      if let alarmDate = self.alarm?.fireDate
      {
         self.informativeTimeLabel.text = AlarmCountdownUtility.countdownTextForAlarmDate(alarmDate)
      }
   }
}
