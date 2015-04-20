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
   override init(tableView: UITableView)
   {
      super.init(tableView: tableView)
      self.cellLabelDictionary = [0 : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]]
   }
}
