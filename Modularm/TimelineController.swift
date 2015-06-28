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
   
   private var configurationController: AlarmConfigurationController
   
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
   
   required init(coder aDecoder: NSCoder)
   {
      self.configurationController = UIStoryboard.controllerWithIdentifier("AlarmConfigurationController") as! AlarmConfigurationController
      super.init(coder: aDecoder)
   }

   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      self.timelineDataSource.removeIncompleteAlarms()
      self.navigationController?.navigationBar.hideBottomHairline()

      self.collectionView.registerNib(UINib(nibName: "TimelineHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
      
      self.collectionView.registerNib(UINib(nibName: "TimelineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "timelineCell")

      let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 50)
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

   // MARK: - IBActions
   @IBAction func addNewAlarmButtonPressed()
   {
      self.configurationController.createNewAlarm()
      self.navigationController?.pushViewController(self.configurationController, animated: true)
   }
   
   @IBAction func logCurrentScheduledNotifications()
   {
      AlarmScheduler.logCurrentScheduledNotifications()
   }
   
   // MARK: - Public
   func openSettingsForAlarm(alarm: Alarm)
   {
      self.configurationController.configureWithAlarm(alarm)
      self.navigationController?.pushViewController(self.configurationController, animated: true)
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
