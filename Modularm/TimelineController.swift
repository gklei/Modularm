//
//  AlarmHistoryController.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class TimelineController: UIViewController
{
   @IBOutlet weak var timelineDataSource: TimelineDataSource!

   override func viewDidLoad()
   {
      super.viewDidLoad()
      setupNavigationBar()
   }

   private func setupNavigationBar()
   {
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
      self.navigationController?.navigationBar.shadowImage = UIImage()

      let rgbValue: CGFloat = 12/255.0
      self.navigationController?.navigationBar.backgroundColor = UIColor(red: rgbValue, green: rgbValue, blue: rgbValue, alpha: 1)
   }

   @IBAction func insertAlarm(sender: AnyObject)
   {
   }

   @IBAction func addAlarmButtonPressed()
   {
      println("add alarm button pressed")
   }
}
