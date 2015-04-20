//
//  SnoozeOptionDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SnoozeOptionDelegateDataSource: NSObject, UITableViewDataSource
{
   var tableView: UITableView

   init(tableView: UITableView)
   {
      self.tableView = tableView
      super.init()

      tableView.dataSource = self
      tableView.delegate = self
   }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 4
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

      if indexPath.row == 0
      {
         cell.accessoryType = .DisclosureIndicator
         cell.textLabel!.text = "Snooze Time"
      }
      else if indexPath.row == 1
      {
         cell.textLabel!.text = "Regular"
      }
      else if indexPath.row == 2
      {
         cell.textLabel!.text = "Big"
      }
      else if indexPath.row == 3
      {
         cell.textLabel!.text = "Shake your phone"
      }
      return cell
   }
}

extension SnoozeOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()

      let cancelButton = UIButton()
      var attrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!,
         NSForegroundColorAttributeName : UIColor.lightGrayColor()]
      var highlightedAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 19)!,
         NSForegroundColorAttributeName : UIColor(white: 0.8, alpha: 1)]

      let normalAttrTitle = NSAttributedString(string: "cancel", attributes: attrs)
      let hightlightedAttrTitle = NSAttributedString(string: "cancel", attributes: highlightedAttrs)

      cancelButton.setAttributedTitle(normalAttrTitle, forState: .Normal)
      cancelButton.setAttributedTitle(hightlightedAttrTitle, forState: .Highlighted)

      cancelButton.sizeToFit()

      view.addSubview(cancelButton)
      cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)

      return view
   }

   func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
   {
      return 50.0
   }

   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {g
   }
}
