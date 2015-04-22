//
//  SnoozeOptionDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SnoozeOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   let firstMenuTitles = ["Snooze", "Regular button", "Big button", "Shake your phone"]
   let secondMenuTitles = ["5 minutes", "10 minutes", "15 minutes", "20 minutes"]
   var isShowingFirstMenu: Bool {
      didSet {
         if (self.isShowingFirstMenu)
         {
            self.settingsControllerDelegate.updateSetOptionButtonClosure(nil)
            self.settingsControllerDelegate.resetSetOptionButtonTitle()
         }
         else
         {
            self.settingsControllerDelegate.updateSetOptionButtonTitle("Set snooze time")
            self.settingsControllerDelegate.updateSetOptionButtonClosure({ () -> () in
               self.isShowingFirstMenu = true
               self.tableView.reloadData()
            })
         }
      }
   }
   
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      self.isShowingFirstMenu = true
      super.init(tableView: tableView, delegate: delegate)
      self.cellLabelDictionary = [0 : firstMenuTitles]
      self.option = .Snooze
   }
}

extension SnoozeOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      self.cellLabelDictionary = self.isShowingFirstMenu ? [0 : firstMenuTitles] : [0 : secondMenuTitles]
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      if indexPath.row == 0
      {
         cell.accessoryType = self.isShowingFirstMenu ? .DisclosureIndicator : .None
         cell.selectionStyle = self.isShowingFirstMenu ? .Default : .None
      }
      
      return cell
   }
}

extension SnoozeOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if self.isShowingFirstMenu
      {
         self.isShowingFirstMenu = false
         self.tableView.reloadData()
      }
   }
}
