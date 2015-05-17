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
   @IBOutlet weak var collectionView: UICollectionView!
   @IBOutlet weak var timelineController: TimelineController!
   
   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let coreDataStack = CoreDataStack.defaultStack

      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fireDateValue", ascending: true)];

      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

      controller.performFetch(nil)
      controller.delegate = self

      return controller
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
   func reloadData()
   {
      self.collectionView.reloadData()
   }
   
   func alarms() -> [Alarm]?
   {
      return self.fetchedResultsController.fetchedObjects as? [Alarm]
   }
}

// MARK: - UICollectionView Data Source
extension TimelineDataSource: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      let objects = self.fetchedResultsController.fetchedObjects
      let count = objects?.count

      return count!
   }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell: TimelineCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("timelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell

      let alarmEntry: Alarm = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Alarm
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "h:mm"
      
      var prettyAlarmDate = dateFormatter.stringFromDate(alarmEntry.fireDate)
      
      dateFormatter.dateFormat = "aa"
      var amOrPm = dateFormatter.stringFromDate(alarmEntry.fireDate).lowercaseString
      prettyAlarmDate += " \(amOrPm)"
      
      dateFormatter.dateFormat = "EEEE"
      
      var alarmMessage = ""
      if alarmEntry.message != nil
      {
         alarmMessage = "  \(alarmEntry.message!.text)"
      }
      else
      {
         alarmMessage = "  \(dateFormatter.stringFromDate(alarmEntry.fireDate))"
      }
      
      let attributedText = NSAttributedString(boldText: prettyAlarmDate, text: alarmMessage, color: UIColor.whiteColor())
      cell.label.attributedText = attributedText
      
      return cell
   }

   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
   {
      if (equal(kind, UICollectionElementKindSectionHeader))
      {
         let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! TimelineHeaderView
         return header
      }
      return UICollectionReusableView()
   }
}

// MARK: - NSFetchedResultsController Delegate
extension TimelineDataSource: NSFetchedResultsControllerDelegate
{
   func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
   {
      if type != NSFetchedResultsChangeType.Insert
      {
         self.reloadData()
      }
   }
}
