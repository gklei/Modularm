//
//  AlarmTimeController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/26/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmTimeController: UIViewController
{
   @IBOutlet weak var hourLabel: UILabel!
   @IBOutlet weak var minuteLabel: UILabel!
   @IBOutlet weak var colonLabel: UILabel!
   
   @IBOutlet weak var alarmWillGoOffInLabel: UILabel!
   @IBOutlet weak var alarmTimeLabel: UILabel!
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      self.view.backgroundColor = UIColor.clearColor()
      self.hourLabel.textColor = UIColor.whiteColor()
      self.minuteLabel.textColor = UIColor.whiteColor()
      self.colonLabel.textColor = UIColor.whiteColor()
      self.alarmWillGoOffInLabel.textColor = UIColor.whiteColor()
      self.alarmTimeLabel.textColor = UIColor.whiteColor()
   }
}
