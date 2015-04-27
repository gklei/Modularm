//
//  SnoozeOptionDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class SnoozeOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var snoozeModel: Snooze
   var state: SnoozeOptionSettingState?

   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      let coreDataStack = CoreDataStack.defaultStack
      self.snoozeModel = NSEntityDescription.insertNewObjectForEntityForName("Snooze", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Snooze

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
   var snoozeModel: Snooze {get set}
   var cellLabelDictionary: [Int : Array<String>]? {get set}
   func transitionToState(state: SnoozeOptionSettingState)
   func reloadData()
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

   func reloadData()
   {
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
      self.delegate.cellLabelDictionary = [0 : ["Snooze \(self.delegate.snoozeModel.durationValue) minutes", "Regular button", "Big button", "Shake your phone"]]
   }
   
   func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
   {
      let snoozeTimeOptionIndex = kSnoozeTimeOptionIndex
      if indexPath.row == snoozeTimeOptionIndex
      {
         cell.accessoryType = .DisclosureIndicator
         cell.selectionStyle = .Default
      }
      else
      {
         cell.accessoryType = indexPath.row == self.cellIndexForSnoozeType(self.delegate.snoozeModel.type) ? .Checkmark : .None
      }
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if indexPath.row == kSnoozeTimeOptionIndex
      {
         let snoozeOptionSettingTimeState = SnoozeOptionSettingTimeState(delegate: self.delegate)
         self.delegate.transitionToState(snoozeOptionSettingTimeState)
      }
      else
      {
         if let type = self.snoozeTypeForCellIndex(indexPath.row)
         {
            self.delegate.snoozeModel.type = type
            self.delegate.reloadData()
         }
      }
   }

   private func cellIndexForSnoozeType(type: SnoozeType) -> Int
   {
      var index = 1
      switch type
      {
      case .RegularButton:
         break
      case .BigButton:
         index = 2
      case .ShakePhone:
         index = 3
      }
      return index
   }

   private func snoozeTypeForCellIndex(index: Int) -> SnoozeType?
   {
      var snoozeType: SnoozeType?
      switch index
      {
      case 1:
         snoozeType = .RegularButton
      case 2:
         snoozeType = .BigButton
      case 3:
         snoozeType = .ShakePhone
      default:
         break
      }
      return snoozeType
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
      cell.accessoryType = indexPath.row == self.cellIndexForSnoozeDuration(self.delegate.snoozeModel.duration) ? .Checkmark : .None
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if let duration = self.snoozeDurationForCellIndex(indexPath.row)
      {
         self.delegate.snoozeModel.duration = duration
         self.delegate.reloadData()
      }
   }

   private func cellIndexForSnoozeDuration(duration: SnoozeDuration) -> Int
   {
      var index = 0
      switch duration
      {
      case .FiveMinutes:
         break
      case .TenMinutes:
         index = 1
      case .FifteenMinutes:
         index = 2
      case .TwentyMinutes:
         index = 3
      }
      return index
   }

   private func snoozeDurationForCellIndex(index: Int) -> SnoozeDuration?
   {
      var snoozeDuration: SnoozeDuration?
      switch index
      {
      case 0:
         snoozeDuration = .FiveMinutes
      case 1:
         snoozeDuration = .TenMinutes
      case 2:
         snoozeDuration = .FifteenMinutes
      case 3:
         snoozeDuration = .TwentyMinutes
      default:
         break
      }
      return snoozeDuration
   }
}
