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
   @IBOutlet weak var collectionView: UICollectionView!

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.navigationController?.navigationBar.hideBottomHairline()
      
      let nib = UINib(nibName: "TimelineCollectionViewCell", bundle: nil)
      self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "timelineCell")
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
         let configurationController = segue.destinationViewController as! AlarmConfigurationController
         configurationController.createNewAlarm()
      }
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      let configurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
      configurationController.configureWithAlarm(alarm)
      self.navigationController?.pushViewController(configurationController, animated: true)
   }

   // MARK: - Private
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
}
