//
//  AlarmViewController.swift
//  Modularm
//
//  Created by Klein, Greg on 6/27/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController
{
   @IBOutlet weak var alarmLabel: UILabel!
   private var alarm: Alarm?
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
   }
   
   func configureWithAlarm(alarm: Alarm)
   {
      self.alarm = alarm
      self.alarmLabel.text = "Alarm: \(alarm.fireDate.prettyDateString())\n\(alarm.identifier)"
   }
}
