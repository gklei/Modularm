//
//  AlarmOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionDelegateDataSource: NSObject
{
   internal var tableView: UITableView
   
   init(tableView: UITableView)
   {
      self.tableView = tableView
      super.init()
      
      tableView.dataSource = self
      tableView.delegate = self
   }
}

extension AlarmOptionDelegateDataSource: UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return 0
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
      return cell
   }
}

extension AlarmOptionDelegateDataSource: UITableViewDelegate
{
}
