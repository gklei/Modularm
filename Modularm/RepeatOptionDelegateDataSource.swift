//
//  RepeatOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class RepeatOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var repeatModel: Repeat?
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.repeatModel = CoreDataStack.newModelWithOption(.Repeat) as? Repeat
      if let repeat = alarm?.repeat
      {
         for day in RepeatDay.valueArray()
         {
            self.repeatModel?.enableDay(day, enabled: repeat.dayIsEnabled(day))
         }
      }
      
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Repeat
      self.cellLabelDictionary = [0 : ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]]
      self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: self.repeatModel)
   }
   
   override func saveSettings()
   {
      if self.repeatModel!.atLeastOneDayIsEnabled {
         self.alarm?.repeat = self.repeatModel!
      }
   }
   
   private func cellIndexForRepeatDay(day: RepeatDay) -> Int
   {
      return Int(day.rawValue)
   }
   
   private func repeatDayForCellIndex(index: Int) -> RepeatDay?
   {
      return RepeatDay(rawValue: Int16(index))
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      if let day = self.repeatDayForCellIndex(indexPath.row)
      {
         var accessoryImageTintColor = UIColor(white: 0.95, alpha: 1)
         if self.repeatModel!.dayIsEnabled(day) {
            accessoryImageTintColor = UIColor.lipstickRedColor()
         }
         
         let accessoryViewImage = UIImage(named:"ic_check")!
         let accessoryImageView = UIImageView(image: accessoryViewImage)
         cell.tintColor = accessoryImageTintColor
         cell.selectionStyle = .None
         cell.accessoryView = accessoryImageView
      }
      return cell
   }
}

extension RepeatOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if let day = self.repeatDayForCellIndex(indexPath.row)
      {
         var shouldEnable = !self.repeatModel!.dayIsEnabled(day)
         self.repeatModel!.enableDay(day, enabled: shouldEnable)
         self.tableView.reloadData()
      }
   }
}
