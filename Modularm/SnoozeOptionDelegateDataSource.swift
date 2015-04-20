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
   var isShowingFirstMenu = true
   
   override init(tableView: UITableView)
   {
      super.init(tableView: tableView)
      self.cellLabelDictionary = [0 : firstMenuTitles]
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
      self.isShowingFirstMenu = !self.isShowingFirstMenu
      self.tableView.reloadData()
   }
}
