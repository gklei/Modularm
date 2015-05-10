//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class AlarmOptionSettingsController: OptionSettingsControllerBase
{
   @IBOutlet weak var tableView: UITableView!
   var setOptionButtonClosure: (() -> ())?
   var delegateDataSource: AlarmOptionDelegateDataSource?

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      self.delegateDataSource = self.delegateDataSourceForOption(self.option)
   }
   
   override func viewDidAppear(animated: Bool)
   {
      super.viewDidAppear(animated)
      self.tableView.flashScrollIndicators()
   }
   
   @IBAction func setOptionButtonPressed()
   {
      if let closure = self.setOptionButtonClosure
      {
         closure()
      }
      else
      {
         self.delegateDataSource?.saveSettings()
         CoreDataStack.save()
         self.dismissSelf()
      }
   }
}

extension AlarmOptionSettingsController: AlarmOptionSettingsControllerDelegate
{
   func cancelButtonPressed()
   {
      self.dismissSelf()
   }
   
   func deleteSettingsButtonPressedWithOption(option: AlarmOption)
   {
      var alarmAttribute: NSManagedObject?
      switch option
      {
      case .Countdown:
         alarmAttribute = self.alarm?.countdown
         break
      case .Date:
         alarmAttribute = self.alarm?.date
         break
      case .Message:
         alarmAttribute = self.alarm?.message
         break
      case .Music:
         break
      case .Repeat:
         alarmAttribute = self.alarm?.repeat
         break
      case .Snooze:
         alarmAttribute = self.alarm?.snooze
         break
      case .Sound:
         alarmAttribute = self.alarm?.sound
         break
      case .Weather:
         alarmAttribute = self.alarm?.weather
         break
      case .Unknown:
         break
      }
      
      CoreDataStack.deleteObject(alarmAttribute)
      self.dismissSelf()
   }
   
   func updateSetOptionButtonClosure(closure: (() -> ())?)
   {
      self.setOptionButtonClosure = closure
   }
   
   func updateSetOptionButtonTitle(title: String)
   {
      UIView.setAnimationsEnabled(false)
      self.setOptionButton.setTitle(title, forState: .Normal)
      self.setOptionButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true);
   }
   
   func resetSetOptionButtonTitle()
   {
      let title = self.buttonTitleForOption(self.option)
      self.updateSetOptionButtonTitle(title)
   }
}

extension AlarmOptionSettingsController
{
   private func delegateDataSourceForOption(option: AlarmOption) -> AlarmOptionDelegateDataSource
   {
      var delegateDataSource: AlarmOptionDelegateDataSource
      switch (option)
      {
      case .Countdown:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Date:
         delegateDataSource = DateOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Music:
         delegateDataSource = MusicOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Repeat:
         delegateDataSource = RepeatOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Snooze:
         delegateDataSource = SnoozeOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Sound:
         delegateDataSource = SoundOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      case .Weather:
         delegateDataSource = WeatherOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
         
      case .Message, .Unknown:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self, alarm: self.alarm)
         break
      }
      return delegateDataSource
   }
}
