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
   let snoozeTimeTitles = ["5 minutes", "10 minutes", "15 minutes", "20 minutes"]
   var isShowingFirstMenu = true
}

extension SnoozeOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 4
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      var titleAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!]
      
      var cellLabel = ""
      if indexPath.row == 0
      {
         cellLabel = "Snooze"
         cell.accessoryType = self.isShowingFirstMenu ? .DisclosureIndicator : .None
         cell.selectionStyle = self.isShowingFirstMenu ? .Default : .None
      }
      else if indexPath.row == 1
      {
         cellLabel = "Regular button"
         cell.selectionStyle = .None
      }
      else if indexPath.row == 2
      {
         cellLabel = "Big button"
         cell.selectionStyle = .None
      }
      else if indexPath.row == 3
      {
         cellLabel = "Shake your phone"
         cell.selectionStyle = .None
      }
      
      cellLabel = self.isShowingFirstMenu ? self.firstMenuTitles[indexPath.row] : self.snoozeTimeTitles[indexPath.row]
      cell.textLabel?.attributedText = NSAttributedString(string: cellLabel, attributes: titleAttrs);
      
      return cell
   }
}

extension SnoozeOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()

      let cancelButton = UIButton.cancelButtonWithTitle("cancel")
      cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)
      view.addSubview(cancelButton)

      return view
   }

   func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
   {
      return 50.0
   }

   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.isShowingFirstMenu = !self.isShowingFirstMenu
      self.tableView.reloadData()
   }
}
