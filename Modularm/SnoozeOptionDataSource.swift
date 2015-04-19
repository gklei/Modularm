//
//  SnoozeOptionDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SnoozeOptionDataSource: NSObject, UITableViewDataSource
{
   var tableView: UITableView

   init(tableView: UITableView)
   {
      self.tableView = tableView
      super.init()

      tableView.dataSource = self
   }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 4
   }

   // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
   // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

      if indexPath.row == 0
      {
         cell.accessoryType = .DisclosureIndicator
      }
      return cell
   }
}
