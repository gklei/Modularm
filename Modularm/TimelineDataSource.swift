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
   
   private var sectionChanges = Array<Dictionary<NSFetchedResultsChangeType, Int>>()
   private var objectChanges = Array<Dictionary<NSFetchedResultsChangeType, NSIndexPath?>>()
   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let coreDataStack = CoreDataStack.defaultStack

      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "active", ascending: false), NSSortDescriptor(key: "fireDateValue", ascending: true)];

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
      var numberOfItems = 0
      if self.fetchedResultsController.sections?.count > 0
      {
         if let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo
         {
            numberOfItems = sectionInfo.numberOfObjects
         }
      }

      if section == kActiveAlarmSectionIndex && numberOfItems > 0
      {
         numberOfItems--
      }
      
      return numberOfItems
   }

   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell: TimelineCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("timelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell

      var newIndexPath = indexPath
      if indexPath.section == kActiveAlarmSectionIndex
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
//      var change = Dictionary<NSFetchedResultsChangeType, NSIndexPath?>()
//      switch type
//      {
//      case .Insert:
//         change[type] = newIndexPath
//         break
//      case .Delete, .Update:
//         change[type] = indexPath
//         break
//      case .Move:
//         break
//      }
//      
//      self.objectChanges.append(change)
   }
//
//   func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
//   {
//      var change = Dictionary<NSFetchedResultsChangeType, Int>()
//      switch type
//      {
//      case .Insert, .Delete:
//         change[type] = sectionIndex
//         break
//      case .Move, .Update:
//         break
//      }
//      
//      self.sectionChanges.append(change)
//   }
//   
//   func controllerDidChangeContent(controller: NSFetchedResultsController)
//   {
//      let collectionView = self.timelineController.collectionView
////      if ([_sectionChanges count] > 0)
////      {
////         [self.collectionView performBatchUpdates:^{
////            
////            for (NSDictionary *change in _sectionChanges)
////            {
////            [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
////            
////            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
////            switch (type)
////            {
////            case NSFetchedResultsChangeInsert:
////            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
////            break;
////            case NSFetchedResultsChangeDelete:
////            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
////            break;
////            case NSFetchedResultsChangeUpdate:
////            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
////            break;
////            }
////            }];
////            }
////            } completion:nil];
//      
//      if self.sectionChanges.count > 0
//      {
//         collectionView.performBatchUpdates({ () -> Void in
//            
//            for change in self.sectionChanges
//            {
//               for (type, section) in change
//               {
//                  switch type
//                  {
//                  case .Insert:
//                     collectionView.insertSections(NSIndexSet(index: section))
//                     break
//                  case .Delete:
//                     collectionView.deleteSections(NSIndexSet(index: section))
//                     break
//                  case .Move:
//                     break
//                  case .Update:
//                     collectionView.reloadSections(NSIndexSet(index: section))
//                     break
//                  }
//               }
//            }
//            
//            }, completion: { (finished: Bool) -> Void in
//         })
//      }
//      
//      if self.objectChanges.count > 0 && self.sectionChanges.count == 0
//      {
//         collectionView.performBatchUpdates({ () -> Void in
//            
//            for change in self.objectChanges
//            {
//               for (type, indexPath) in change
//               {
//                  if let idxPath = indexPath
//                  {
//                     switch type
//                     {
//                     case .Insert:
//                        collectionView.insertItemsAtIndexPaths([idxPath])
//                        break
//                     case .Delete:
//                        collectionView.deleteItemsAtIndexPaths([idxPath])
//                        break
//                     case .Move:
//                        break
//                     case .Update:
//                        collectionView.reloadItemsAtIndexPaths([idxPath])
//                        break
//                     }
//                  }
//               }
//            }
//            
//            }, completion: { (finished: Bool) -> Void in
//         })
//      }
//      self.objectChanges.removeAll(keepCapacity: false)
//      self.sectionChanges.removeAll(keepCapacity: false)
//   }
   
//   func controllerDidChangeContent(controller: NSFetchedResultsController)
//   {
//      self.timelineController.reloadData()
//   }
}