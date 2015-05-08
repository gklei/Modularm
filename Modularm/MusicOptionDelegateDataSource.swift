//
//  MusicOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class MusicOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol, alarm: Alarm?)
   {
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Music
      self.cellLabelDictionary = [0 :["itunes", "spotify", "rdio", "fmetc"]]
   }
}

// MARK: - Private
extension MusicOptionDelegateDataSource
{
   func itunesSwitchChanged(sender: UISwitch)
   {
      println("itunes switch changed")
   }

   func spotifySwitchChanged(sender: UISwitch)
   {
      println("spotify switch changed")
   }

   func rdioSwitchChanged(sender: UISwitch)
   {
      println("rdio switch changed")
   }

   func fmetcSwitchChanged(sender: UISwitch)
   {
      println("fmetc switch changed")
   }
   
   override func deleteSettings()
   {
      println("delete \(self.option.description)!")
   }
}

// MARK: - UITableView Delegate
extension MusicOptionDelegateDataSource: UITableViewDelegate
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      let switchView = UISwitch()
      switchView.setOn(false, animated: false)
      
      var selectorString: Selector? = nil
      switch (indexPath.row)
      {
      case 0:
         selectorString = "itunesSwitchChanged:"
         break;
      case 1:
         selectorString = "spotifySwitchChanged:"
         break;
      case 2:
         selectorString = "rdioSwitchChanged:"
         break;
      case 3:
         selectorString = "fmetcSwitchChanged:"
         break;
         
      default:
         break;
      }
      
      if let selector = selectorString
      {
         switchView.addTarget(self, action: selector, forControlEvents: UIControlEvents.ValueChanged)
         cell.accessoryView = switchView
      }
      
      return cell
   }
   
//   override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
//   {
//      let view = super.tableView(tableView, viewForFooterInSection: section)
//      if section == 0
//      {
//         let label = UILabel()
//         label.font = UIFont(name: "Helvetica Neue", size: 16)
//         label.text = "SOURCE"
//         label.sizeToFit()
//         
//         label.center = CGPointMake(CGRectGetWidth(label.frame)*0.5 + 16, 25)
//         view?.addSubview(label)
//      }
//      return view
//   }
}
