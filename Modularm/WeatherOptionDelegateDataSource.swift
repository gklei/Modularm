//
//  WeatherOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class WeatherOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   // MARK - Instance Variables
   let backgroundPhotoOnOffSwitch = UISwitch()
   let locationAutoOnOffSwitch = UISwitch()

   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Weather
      self.cellLabelDictionary = [0 :["34.4ºF slightly Rainy US", "3ºC slightly Rainy EU", "slighty Rainy int"],
         1 : ["Background Photo", "Location Auto"]]
      
      self.backgroundPhotoOnOffSwitch.setOn(true, animated: false)
      self.backgroundPhotoOnOffSwitch.addTarget(self, action: "backgroundPhotoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
      
      self.locationAutoOnOffSwitch.setOn(true, animated: false)
      self.locationAutoOnOffSwitch.addTarget(self, action: "locationAutoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
   }
}

// MARK: - Private
extension WeatherOptionDelegateDataSource
{
   func backgroundPhotoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
   }

   func locationAutoSwitchChanged(sender: UISwitch)
   {
      println("location auto on: \(sender.on)")
   }
}

// MARK: - UITableView Data Source
extension WeatherOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      if indexPath.section == 1
      {
         let onOffSwitch = indexPath.row == 0 ? self.backgroundPhotoOnOffSwitch : self.locationAutoOnOffSwitch
         cell.accessoryView = onOffSwitch
      }
      
      return cell
   }
}
