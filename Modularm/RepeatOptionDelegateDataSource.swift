//
//  RepeatOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class RepeatOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var repeatModel: Repeat
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      let coreDataStack = CoreDataStack.defaultStack
      self.repeatModel = NSEntityDescription.insertNewObjectForEntityForName("Repeat", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Repeat
      
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Repeat
      self.cellLabelDictionary = [0 : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]]
   }
}
