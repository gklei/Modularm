//
//  File.swift
//  Modularm
//
//  Created by Klein, Greg on 7/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

struct AlarmManager
{
   static var sharedInstance = AlarmManager()
   
   private let coreDataStack = CoreDataStack.defaultStack
   
   lazy var fetchedResultsController: NSFetchedResultsController = {
      let coreDataStack = CoreDataStack.defaultStack
      
      let fetchRequest = NSFetchRequest(entityName: "Alarm")
      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "active", ascending: false), NSSortDescriptor(key: "fireDateValue", ascending: true)];
      
      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: "active", cacheName: nil)
      
      controller.performFetch(nil)
      
      return controller
      }()
   
   // MARK: - Public
   
   static var alarms: [Alarm]? {
      return self.sharedInstance.fetchedResultsController.fetchedObjects as? [Alarm]
   }
   
   static var activeAlarms: [Alarm]? {
      var alarmArray = Array<Alarm>()
      if let alarms = self.alarms
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
   
   static var nonActiveAlarms: [Alarm]? {
      var alarmArray = Array<Alarm>()
      if let alarms = self.alarms
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
