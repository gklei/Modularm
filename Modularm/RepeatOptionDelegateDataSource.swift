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
      if let repeatModel = alarm?.repeatModel
      {
         for day in RepeatDay.valueArray()
         {
            self.repeatModel?.enableDay(day, enabled: repeatModel.dayIsEnabled(day))
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
         self.alarm?.repeatModel = self.repeatModel!
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

extension RepeatOptionDelegateDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
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

extension RepeatOptionDelegateDataSource
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if let day = self.repeatDayForCellIndex(indexPath.row)
      {
         let shouldEnable = !self.repeatModel!.dayIsEnabled(day)
         self.repeatModel!.enableDay(day, enabled: shouldEnable)
         self.tableView.reloadData()
         self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: self.repeatModel)
      }
   }
}
