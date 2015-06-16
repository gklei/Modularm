//
//  TimelineHeaderView.swift
//  Modularm
//
//  Created by Gregory Klein on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimelineHeaderView: UICollectionReusableView
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var amOrPmLabel: UILabel!
   
   @IBOutlet weak var innerContentView: UIView!
   @IBOutlet weak var scrollView: TapScrollView!
   
   private var deleteButton: UIButton = UIButton.timelineCellDeleteButton()
   private var toggleButton: UIButton = UIButton.timelineCellToggleButton()
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
   var alarm: Alarm?
   weak var timelineController: TimelineController?
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      
      self.hourLabel.text = TimeDisplayProvider.textForHourValue(alarm.fireDate.hour)
      self.minuteLabel.text = TimeDisplayProvider.textForMinuteValue(alarm.fireDate.minute)
      self.amOrPmLabel.text = alarm.fireDate.hour < 12 ? "am" : "pm"
   }
   
   @IBAction func editButtonPressed()
   {
      if let controller = self.timelineController, alarm = self.alarm
      {
         controller.openSettingsForAlarm(alarm)
      }
   }
}
