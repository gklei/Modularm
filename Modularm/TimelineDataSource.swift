//
//  TimelineDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class TimelineDataSource: NSObject
{
   // MARK: - Instance Variables
   @IBOutlet weak var timelineController: TimelineController!
   
   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let coreDataStack = CoreDataStack.defaultStack

      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fireDateValue", ascending: true)];

      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: "active", cacheName: nil)

      controller.performFetch(nil)
      controller.delegate = self

      return controller
   }()
   
   lazy var dateFormatter: NSDateFormatter =
   {
      let formatter = NSDateFormatter()
      return formatter
   }()
   
   func removeIncompleteAlarms()
   {
      if let alarms = self.fetchedResultsController.fetchedObjects as? [Alarm]
      {
         for alarm in alarms
         {
            if !alarm.completedSetup
            {
               CoreDataStack.deleteObject(alarm)
            }
         }
      }
   }

   // MARK: - Public
   func alarms() -> [Alarm]?
   {
      return self.fetchedResultsController.fetchedObjects as? [Alarm]
   }
   
   func activeAlarms() -> [Alarm]?
   {
      var alarmArray = Array<Alarm>()
      if let alarms = self.alarms()
      {
         for alarm in alarms
         {
            if alarm.active
            {
               alarmArray.append(alarm)
            }
         }
      }
      return alarmArray
   }
   
   func nonActiveAlarms() -> [Alarm]?
   {
      var alarmArray = Array<Alarm>()
      if let alarms = self.alarms()
      {
         for alarm in alarms
         {
            if alarm.active == false
            {
               alarmArray.append(alarm)
            }
         }
      }
      return alarmArray
   }
}

// MARK: - UICollectionView Data Source
extension TimelineDataSource: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      var count = 0
      if section == 0
      {
         if let alarms = self.activeAlarms()
         {
            count = alarms.count - 1
         }
         count = max(0, count)
      }
      else
      {
         if let alarms = self.nonActiveAlarms()
         {
            count = alarms.count
         }
      }
      return count
   }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell: TimelineCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("timelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell
      
      var newIndexPath = indexPath
      
      var alarm: Alarm?
      if indexPath.section == 0
      {
         if let alarms = self.activeAlarms()
         {
            alarm = alarms[indexPath.row + 1]
         }
         newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
      }
      else
      {
         if let alarms = self.nonActiveAlarms()
         {
            alarm = alarms[indexPath.row]
         }
      }
      
//      if let alarmEntry: Alarm = self.fetchedResultsController.objectAtIndexPath(newIndexPath) as? Alarm
      if let alarmEntry = alarm
      {
         cell.collectionView = collectionView
         cell.configureWithAlarm(alarm)
      }
      
      return cell
   }

   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
   {
      if equal(kind, UICollectionElementKindSectionHeader)
      {
         let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TimelineHeaderView
         
         if let alarmArray = self.alarms()
         {
            if alarmArray.count > 0
            {
               header.timelineController = self.timelineController
               header.configureWithAlarm(alarmArray[0])
            }
         }
         return header
      }
      return UICollectionReusableView()
   }
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
   {
      return 2
   }
}

// MARK: - NSFetchedResultsController Delegate
extension TimelineDataSource: NSFetchedResultsControllerDelegate
{
   func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
   {
      if type != NSFetchedResultsChangeType.Insert
      {
         self.timelineController.reloadData()
      }
   }
}
