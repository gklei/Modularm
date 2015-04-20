//
//  MusicOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let itunesIndex = 0
let spotifyIndex = 1
let rdioIndex = 2
let fmetcIndex = 3

class MusicOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   override init(tableView: UITableView)
   {
      super.init(tableView: tableView)
      self.cellLabelDictionary = [0 :["itunes", "spotify", "rdio", "fmetc"]]
   }
   
   func itunesSwitchChanged(sender: UISwitch)
   {
   }
   
   func spotifySwitchChanged(sender: UISwitch)
   {
   }
   
   func rdioSwitchChanged(sender: UISwitch)
   {
   }
   
   func fmetcSwitchChanged(sender: UISwitch)
   {
   }
}

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
      }
      
      cell.accessoryView = switchView
      
      return cell
   }
}
