//
//  DateOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class DateOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var dateModel: Date?
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.dateModel = CoreDataStack.newModelWithOption(.Date) as? Date
      if let date = alarm?.date
      {
         self.dateModel?.displayType = date.displayType
      }
      
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Date
      self.cellLabelDictionary = [0 :["tuesday 04/10", "10.04 tuesday", "tuesday"]]
   }
   
   override func saveSettings()
   {
      self.alarm?.date = self.dateModel!
   }

   private func stringForDisplayType(type: DateDisplayType) -> String?
   {
      var string: String?
      switch type
      {
      case .US:
         string = "US"
         break
      case .EU:
         string = "EU"
         break
      case .NoDate:
         string = "without a date"
         break
      }
      return string
   }
   
   private func cellIndexForDateDisplayType(displayType: DateDisplayType) -> Int
   {
      return Int(displayType.rawValue)
   }
   
   private func displayTypeForCellIndex(index: Int) -> DateDisplayType?
   {
      return DateDisplayType(rawValue: Int16(index))
   }
}

extension DateOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)

      if let type = self.displayTypeForCellIndex(indexPath.row), boldString = self.stringForDisplayType(type)
      {
         let label = self.cellLabelDictionary[indexPath.section]![indexPath.row]
         cell.textLabel?.attributedText = NSAttributedString(text: label, boldText: boldString)
      }
      cell.accessoryType = indexPath.row == self.cellIndexForDateDisplayType(self.dateModel!.displayType) ? .Checkmark : .None
      
      return cell
   }
}

extension DateOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.dateModel!.displayType = self.displayTypeForCellIndex(indexPath.row)!
      self.tableView.reloadData()
   }
}
