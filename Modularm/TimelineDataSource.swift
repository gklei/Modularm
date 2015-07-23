//
//  TimelineDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/11/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

let kTotalSectionsInTimelineCollectionView = 2
let kActiveAlarmSectionIndex = 0
let kNonActiveAlarmSectionIndex = 1

class TimelineDataSource: NSObject
{
   // MARK: - Instance Variables
   @IBOutlet weak var timelineController: TimelineController!

   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let controller = AlarmManager.sharedInstance.fetchedResultsController
      controller.delegate = self
      return controller
   }()
   
   private lazy var dateFormatter: NSDateFormatter =
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
}

// MARK: - UICollectionView Data Source
extension TimelineDataSource: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      var numberOfItems = 0
      if self.fetchedResultsController.sections?.count > 0
      {
         if let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
         {
            numberOfItems = section == kActiveAlarmSectionIndex ? max(0, sectionInfo.numberOfObjects - 1) : sectionInfo.numberOfObjects
            
            if AlarmManager.activeAlarms?.count == 0 {
               numberOfItems = sectionInfo.numberOfObjects
            }
         }
      }
      
      return numberOfItems
   }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell: TimelineCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("timelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell

      var newIndexPath = indexPath
      if indexPath.section == kActiveAlarmSectionIndex && AlarmManager.activeAlarms?.count != 0
      {
         // increment the row by one because the first alarm in the Active section is the header
         newIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
      }

      cell.collectionView = collectionView

      let alarm = self.fetchedResultsController.objectAtIndexPath(newIndexPath) as? Alarm
      cell.configureWithAlarm(alarm)
      return cell
   }

   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
   {
      if equal(kind, UICollectionElementKindSectionHeader)
      {
         let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TimelineHeaderView

         if let alarmArray = AlarmManager.alarms
         {
            if alarmArray.count > 0
            {
               header.timelineController = self.timelineController
               header.configureWithAlarm(alarmArray[0])
               
               let alarm: Alarm? = alarmArray[0]
            }
         }
         return header
      }
      else
      {
         let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath) as! UICollectionReusableView
         return footer
      }
   }
   
   func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
   {
      return self.fetchedResultsController.sections!.count
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