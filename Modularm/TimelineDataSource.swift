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
   private let coreDataStack = CoreDataStack.defaultStack

   lazy var fetchedResultsController: NSFetchedResultsController =
   {
      let coreDataStack = CoreDataStack.defaultStack

      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fireDate", ascending: false)];

      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

      controller.performFetch(nil)
      controller.delegate = self

      return controller
   }()

   // MARK: - Init
   override init()
   {
      super.init()
   }

   // MARK: - Public
   func addAlarm()
   {
      let coreDataStack = CoreDataStack.defaultStack
      let alarm: Alarm = NSEntityDescription.insertNewObjectForEntityForName("Alarm", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Alarm

      let count = self.fetchedResultsController.fetchedObjects?.count

      coreDataStack.saveContext()
   }
   
   func reloadData()
   {
      self.collectionView.reloadData()
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
      let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell

      let alarmEntry: Alarm = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Alarm
      println(alarmEntry.fireDate)

      return cell
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
