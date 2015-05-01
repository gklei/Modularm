//
//  DateOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class DateOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var dateModel: Date
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      let coreDataStack = CoreDataStack.defaultStack
      self.dateModel = NSEntityDescription.insertNewObjectForEntityForName("Date", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Date
      
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Date
      self.cellLabelDictionary = [0 :["Tuesday 04/10 US", "10.04 Tuesday EU", "Tuesday without a date"]]
   }
   
   private func cellIndexForDateDisplayType(displayType: DateDisplayType) -> Int
   {
      var index = 0
      switch displayType
      {
      case .US:
         break
      case .EU:
         index = 1
         break
      case .NoDate:
         index = 2
         break
      }
      return index
   }
   
   private func displayTypeForCellIndex(index: Int) -> DateDisplayType?
   {
      var displayType: DateDisplayType?
      switch index
      {
      case 0:
         displayType = .US
         break
      case 1:
         displayType = .EU
         break
      case 2:
         displayType = .NoDate
         break
      default:
         break
      }
      return displayType
   }
}

extension DateOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell.accessoryType = indexPath.row == self.cellIndexForDateDisplayType(self.dateModel.displayType) ? .Checkmark : .None
      
      return cell
   }
}

extension DateOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.dateModel.displayType = self.displayTypeForCellIndex(indexPath.row)!
      self.tableView.reloadData()
   }
}
