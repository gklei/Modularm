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
   
   var alarms: [Alarm]? {
      get {
         return self.timelineDataSource.alarms()
      }
   }
   
   var activeAlarms: [Alarm]? {
      get {
         return self.timelineDataSource.activeAlarms()
      }
   }
   
   var nonActiveAlarms: [Alarm]? {
      get {
         return self.timelineDataSource.nonActiveAlarms()
      }
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.navigationController?.navigationBar.hideBottomHairline()

      self.collectionView.registerNib(UINib(nibName: "TimelineHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
      
      self.collectionView.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timelineCell")
   }

   override func viewWillAppear(animated: Bool)
   {
      self.timelineDataSource.removeIncompleteAlarms()

      let headerSize = self.alarms?.count > 0 ? CGSizeMake(CGRectGetWidth(self.view.bounds), 150) : CGSizeZero
      let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.headerReferenceSize = headerSize
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
   
   func reloadData()
   {
      self.collectionView.reloadData()
   }

   // MARK: - Private
   private func updateBackBarButtonItemWithTitle(title: String)
   {
      let barButtonItem = UIBarButtonItem(title: title, style: .Plain, target: nil, action: nil)
      self.navigationItem.backBarButtonItem = barButtonItem
   }
}
