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
         1 : ["Background photo", "Location Auto"]]
   }
}

extension WeatherOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return section == 0 ? 3 : 2
   }
   
   override func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 2
   }
   
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

extension WeatherOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()
      
      if section == 1
      {
         let cancelButton = UIButton.cancelButtonWithTitle("cancel")
         cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)
         view.addSubview(cancelButton)
      }
      return view
   }
   
   func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
   {
      return 50.0
   }
}

extension WeatherOptionDelegateDataSource
{
   func backgroundPhotoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
   }
   
   func locationAutoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
   }
}
