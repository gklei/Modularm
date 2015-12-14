//
//  CoreDataStack.swift
//  Modularm
//
//  Created by Gregory Klein on 4/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject
{
   class var defaultStack: CoreDataStack {
      struct SharedInstance {
         static let instance = CoreDataStack()
      }
      return SharedInstance.instance
   }

   // MARK: - Core Data stack
   lazy var applicationDocumentsDirectory: NSURL = {
      // The directory the application uses to store the Core Data store file. This code uses a directory named "com.purevirtualstudios.Modularm" in the application's documents Application Support directory.
      let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
      return urls[urls.count-1] 
      }()

   lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = NSBundle.mainBundle().URLForResource("Modularm", withExtension: "momd")!
      return NSManagedObjectModel(contentsOfURL: modelURL)!
      }()

   lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
      // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Modularm.sqlite")
      var error: NSError? = nil
      var failureReason = "There was an error creating or loading the application's saved data."

      do {
         try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
      } catch var error1 as NSError {
         error = error1
         coordinator = nil
         // Report any error we got.
         var dict = [String: AnyObject]()
         dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
         dict[NSLocalizedFailureReasonErrorKey] = failureReason
         dict[NSUnderlyingErrorKey] = error
         error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
         // Replace this with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         NSLog("Unresolved error \(error), \(error!.userInfo)")
         abort()
      } catch {
         fatalError()
      }

      return coordinator
      }()

   lazy var managedObjectContext: NSManagedObjectContext? = {
      // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
      let coordinator = self.persistentStoreCoordinator
      if coordinator == nil
      {
         return nil
      }
      var managedObjectContext = NSManagedObjectContext()
      managedObjectContext.persistentStoreCoordinator = coordinator
      return managedObjectContext
      }()

   // MARK: - Core Data Saving support
   func saveContext()
   {
      if let moc = self.managedObjectContext
      {
         var error: NSError? = nil
         if moc.hasChanges
         {
            do {
               try moc.save()
            } catch let error1 as NSError {
               error = error1
               // Replace this implementation with code to handle the error appropriately.
               // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               NSLog("Unresolved error \(error), \(error!.userInfo)")
//               abort()
               moc.rollback()
            }
         }
      }
   }
   
   func deleteAllObjectsWithName(name: String)
   {
      let context = CoreDataStack.defaultStack.managedObjectContext
      let fetchRequest = NSFetchRequest()
      
      fetchRequest.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: context!)
      fetchRequest.includesPropertyValues = false
      
      let error = NSErrorPointer()
      let alarms: [AnyObject]?
      do {
         alarms = try context?.executeFetchRequest(fetchRequest)
      } catch let error1 as NSError {
         error.memory = error1
         alarms = nil
      }
      
      for alarm in alarms!
      {
         context?.deleteObject(alarm as! NSManagedObject)
      }
      do {
         try context?.save()
      } catch _ {
      }
   }
   
   class func newModelWithOption(option: AlarmOption) -> AnyObject?
   {
      var managedObject: AnyObject?
      if option != .Unknown
      {
         if let context = self.defaultStack.managedObjectContext
         {
            managedObject = NSEntityDescription.insertNewObjectForEntityForName(option.description, inManagedObjectContext: context)
         }
      }
      return managedObject
   }
   
   class func newTemporaryAlarmModel() -> Alarm?
   {
      var alarm: Alarm?
      if let context = self.defaultStack.managedObjectContext
      {
         if let description = NSEntityDescription.entityForName("Alarm", inManagedObjectContext: context)
         {
            alarm = NSManagedObject(entity: description, insertIntoManagedObjectContext: nil) as? Alarm
         }
      }
      return alarm
   }
   
   class func newAlarmModel() -> Alarm?
   {
      var alarm: Alarm?
      if let context = self.defaultStack.managedObjectContext
      {
         alarm = NSEntityDescription.insertNewObjectForEntityForName("Alarm", inManagedObjectContext: context) as? Alarm
      }
      return alarm
   }
   
   class func newTemporaryModelWithOption(option: AlarmOption) -> AnyObject?
   {
      var managedObject: AnyObject?
      if option != .Unknown
      {
         if let context = self.defaultStack.managedObjectContext
         {
            if let description = NSEntityDescription.entityForName(option.description, inManagedObjectContext: context)
            {
               managedObject = NSManagedObject(entity: description, insertIntoManagedObjectContext: nil) as AnyObject
            }
         }
      }
      return managedObject
   }
   
   class func save()
   {
      self.defaultStack.saveContext()
   }
   
   class func deleteObject(object: NSManagedObject?)
   {
      if let context = self.defaultStack.managedObjectContext
      {
         if object != nil
         {
            context.deleteObject(object!)
         }
      }
   }
   
   class func saveAlarm(alarm: Alarm?)
   {
      if let context = self.defaultStack.managedObjectContext, alarmModel = alarm
      {
         context.insertObject(alarmModel)
         self.defaultStack.saveContext()
      }
   }
}
