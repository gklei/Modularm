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
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Date
      self.cellLabelDictionary = [0 :["Tuesday 04/10 US", "10.04 Tuesday EU", "Tuesday 04/10/2015 US", "Tuesday without a date"]]
   }
}
