//
//  SnoozeOptionDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SnoozeOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var state: SnoozeOptionSettingState?

   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      super.init(tableView: tableView, delegate: delegate)
      self.state = SnoozeOptionSettingButtonState(delegate: self)
      self.option = .Snooze
   }
   
   // MARK: - UITableView Data Source
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      self.state?.configureCell(cell, forRowAtIndexPath: indexPath)
      
      return cell
   }
   
   // MARK: - UITableView Delegate
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.state?.tableView(tableView, didSelectRowAtIndexPath: indexPath)
   }
}


// MARK: - SnoozeOptionSettingStateDelegate Protocol
protocol SnoozeOptionSettingStateDelegate
{
   var cellLabelDictionary: [Int : Array<String>]? {get set}
   func transitionToState(state: SnoozeOptionSettingState)
}

// MARK: - SnoozeOptionSettingStateDelegate Methods
extension SnoozeOptionDelegateDataSource: SnoozeOptionSettingStateDelegate
{
   func transitionToState(state: SnoozeOptionSettingState)
   {
      if state is SnoozeOptionSettingButtonState
      {
         self.settingsControllerDelegate.updateSetOptionButtonClosure(nil)
         self.settingsControllerDelegate.resetSetOptionButtonTitle()
      }
      else if state is SnoozeOptionSettingTimeState
      {
         self.settingsControllerDelegate.updateSetOptionButtonTitle("Set snooze time")
         self.settingsControllerDelegate.updateSetOptionButtonClosure({ () -> () in
            
            let snoozeOptionSettingButtonState = SnoozeOptionSettingButtonState(delegate: self)
            self.transitionToState(snoozeOptionSettingButtonState)
         })
      }
      
      self.state = state;
      self.tableView.reloadData()
   }
}

// MARK: - SnoozeOptionSettingState Protocol -
protocol SnoozeOptionSettingState
{
   var delegate: SnoozeOptionSettingStateDelegate {get}
   func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

// MARK: -
struct SnoozeOptionSettingButtonState: SnoozeOptionSettingState
{
   private let kSnoozeTimeOptionIndex = 0
   var delegate: SnoozeOptionSettingStateDelegate
   
   init(delegate: SnoozeOptionSettingStateDelegate)
   {
      self.delegate = delegate
      self.delegate.cellLabelDictionary = [0 : ["Snooze", "Regular button", "Big button", "Shake your phone"]]
   }
   
   func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
   {
      let snoozeTimeOptionIndex = kSnoozeTimeOptionIndex
      if indexPath.row == snoozeTimeOptionIndex
      {
         cell.accessoryType = .DisclosureIndicator
         cell.selectionStyle = .Default
      }
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if indexPath.row == kSnoozeTimeOptionIndex
      {
         let snoozeOptionSettingTimeState = SnoozeOptionSettingTimeState(delegate: self.delegate)
         self.delegate.transitionToState(snoozeOptionSettingTimeState)
      }
   }
}

// MARK: -
struct SnoozeOptionSettingTimeState: SnoozeOptionSettingState
{
   var delegate: SnoozeOptionSettingStateDelegate
   
   init(delegate: SnoozeOptionSettingStateDelegate)
   {
      self.delegate = delegate
      self.delegate.cellLabelDictionary = [0 : ["5 minutes", "10 minutes", "15 minutes", "20 minutes"]]
   }
   
   func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
   {
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
   }
}
