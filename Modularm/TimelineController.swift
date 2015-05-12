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
   // MARK: - Instance Variables
   @IBOutlet weak var centerNavigationItem: UINavigationItem!
   @IBOutlet weak var timelineDataSource: TimelineDataSource!
   
   private var alarmConfigurationController: AlarmConfigurationController
   
   required init(coder aDecoder: NSCoder)
   {
      self.alarmConfigurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
      super.init(coder: aDecoder)
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.navigationController?.navigationBar.hideBottomHairline()
   }

   override func viewWillAppear(animated: Bool)
   {
      self.timelineDataSource.removeIncompleteAlarms()
   }

   override func viewWillDisappear(animated: Bool)
   {
      self.updateBackBarButtonItemWithTitle("Back")
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if segue.identifier == "addAlarmButtonPressed"
      {
         self.alarmConfigurationController.createNewAlarm()
      }
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      self.alarmConfigurationController.configureWithAlarm(alarm)
      self.navigationController?.pushViewController(self.alarmConfigurationController, animated: true)
   }

   // MARK: - Private
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
}
