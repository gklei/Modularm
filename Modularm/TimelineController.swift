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
   
   var alarmConfigurationController: AlarmConfigurationController?

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.navigationController?.navigationBar.hideBottomHairline()
   }

   override func viewWillAppear(animated: Bool)
   {
      self.timelineDataSource.reloadData()
   }

   override func viewWillDisappear(animated: Bool)
   {
      self.updateBackBarButtonItemWithTitle("Back")
   }

   // MARK: - Private
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if segue.identifier == "addAlarmButtonPressed"
      {
         self.alarmConfigurationController = segue.destinationViewController as? AlarmConfigurationController
         self.alarmConfigurationController?.createNewAlarm()
      }
   }
}
