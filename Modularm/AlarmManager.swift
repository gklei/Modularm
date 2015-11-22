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
      
      do {
         try controller.performFetch()
      } catch _ {
      }
      
      return controller
      }()
   
   // MARK: - Public
   static var alarms: [Alarm]? {
      return self.sharedInstance.fetchedResultsController.fetchedObjects as? [Alarm]
   }
   
   static var activeAlarms: [Alarm] {
      var alarmArray = Array<Alarm>()
      if let alarms = self.alarms
      {
         for alarm in alarms
         {
            if alarm.active && alarm.completedSetup
            {
               alarmArray.append(alarm)
            }
         }
      }
      return alarmArray
   }
   
   static var nonActiveAlarms: [Alarm] {
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
   
   static func removeIncompleteAlarms()
   {
      if let alarmArray = alarms
      {
         for alarm in alarmArray
         {
            if !alarm.completedSetup
            {
               CoreDataStack.delete(alarm)
            }
         }
         CoreDataStack.save()
      }
   }
   
   static func deactivateAlarmsThatAreInThePast()
   {
      let rightNow = NSDate()
      for alarm in activeAlarms {
         if alarm.fireDate < rightNow && alarm.repeatModel == nil && alarm.snooze == nil
         {
            disableAlarm(alarm)
         }
      }
   }
   
   static func disableAlarm(alarm: Alarm)
   {
      alarm.active = false
      alarm.updateAlarmDate()
      AlarmEngine.sharedInstance.cancelAlarm(alarm)
      CoreDataStack.save()
   }
   
   static func createNewAlarm() -> Alarm?
   {
      return CoreDataStack.newAlarmModel()
   }
   
   static func enableAlarm(alarm: Alarm)
   {
      alarm.updateAlarmDate()
      scheduleAlarm(alarm)
   }
   
   static func enableAlarm(alarm: Alarm, withHour hour: Int, minute: Int)
   {
      alarm.fireDate = NSDate.alarmDateWithHour(hour, minute: minute)
      scheduleAlarm(alarm)
   }
   
   static func deleteAlarm(alarm: Alarm)
   {
      AlarmEngine.sharedInstance.cancelAlarm(alarm)
      CoreDataStack.deleteObject(alarm)
      CoreDataStack.save()
   }
   
   private static func scheduleAlarm(alarm: Alarm)
   {
      alarm.active = true
      AlarmEngine.sharedInstance.scheduleAlarm(alarm)
      CoreDataStack.save()
   }
}
