//
//  File.swift
//  Modularm
//
//  Created by Klein, Greg on 5/10/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import UIKit

struct AlarmOptionDelegateDataSourceBuilder
{
   var tableView: UITableView
   var delegate: AlarmOptionSettingsControllerDelegate
   var alarm: Alarm?
   
   init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.tableView = tableView
      self.delegate = delegate
      self.alarm = alarm
   }
   
   func buildWithOption(option: AlarmOption) -> AlarmOptionDelegateDataSource
   {
      var delegateDataSource: AlarmOptionDelegateDataSource
      switch (option)
      {
      case .Countdown:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Date:
         delegateDataSource = DateOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Music:
         delegateDataSource = MusicOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Repeat:
         delegateDataSource = RepeatOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Snooze:
         delegateDataSource = SnoozeOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Sound:
         delegateDataSource = SoundOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      case .Weather:
         delegateDataSource = WeatherOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
         
      case .Message, .Unknown:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self.delegate, alarm: self.alarm)
         break
      }
      return delegateDataSource
   }
}
