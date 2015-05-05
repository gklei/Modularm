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
   var repeatModel: Repeat?
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      CoreDataStack.defaultStack.deleteAllObjectsWithName("Repeat")
      
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Repeat
      self.cellLabelDictionary = [0 : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]]
   }
   
   private func cellIndexForRepeatDay(day: RepeatDay) -> Int
   {
      var index = 0
      switch day
      {
      case .Monday:
         break
      case .Tuesday:
         index = 1
         break
      case .Wednesday:
         index = 2
         break
      case .Thursday:
         index = 3
         break
      case .Friday:
         index = 4
         break
      case .Saturday:
         index = 5
         break
      case .Sunday:
         index = 6
         break
      }
      return index
   }
   
   private func repeatDayForCellIndex(index: Int) -> RepeatDay?
   {
      var day: RepeatDay?
      switch index
      {
      case 0:
         day = .Monday
      case 1:
         day = .Tuesday
      case 2:
         day = .Wednesday
      case 3:
         day = .Thursday
      case 4:
         day = .Friday
      case 5:
         day = .Saturday
      case 6:
         day = .Sunday
      default:
         break
      }
      return day
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      if let day = self.repeatDayForCellIndex(indexPath.row), model = self.repeatModel
      {
         cell.accessoryType = model.dayIsEnabled(day) ? .Checkmark : .None
      }
      return cell
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if let day = self.repeatDayForCellIndex(indexPath.row), model = self.repeatModel
      {
         var shouldEnable = !model.dayIsEnabled(day)
         model.enableDay(day, enabled: shouldEnable)
         
         CoreDataStack.defaultStack.saveContext()
         self.tableView.reloadData()
      }
   }
}
