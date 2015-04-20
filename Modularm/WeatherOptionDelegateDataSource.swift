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
   override init(tableView: UITableView)
   {
      super.init(tableView: tableView)
      self.cellLabelDictionary = [0 :["34.4ºF slightly Rainy US", "3ºC slightly Rainy EU", "slighty Rainy int"],
         1 : ["Background Photo", "Location Auto"]]
   }
   
   func backgroundPhotoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
   }
   
   func locationAutoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
   }
}

extension WeatherOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      if indexPath.section == 1
      {
         let switchView = UISwitch()
         switchView.setOn(true, animated: false)
         
         let selectorString: Selector = indexPath.row == 0 ? "backgroundPhotoSwitchChanged:" : "locationAutoSwitchChanged:"
         switchView.addTarget(self, action: selectorString, forControlEvents: UIControlEvents.ValueChanged)
         
         cell.accessoryView = switchView
      }
      
      return cell
   }
}
