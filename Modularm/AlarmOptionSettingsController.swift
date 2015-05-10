//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class AlarmOptionSettingsController: UIViewController
{
   @IBOutlet weak var setOptionButton: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var iconImageView: UIImageView!
   
   var alarm: Alarm?
   var option: AlarmOption = .Unknown
   var setOptionButtonClosure: (() -> ())?
   var delegateDataSource: AlarmOptionDelegateDataSource?

   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.iconImageView.tintColor = UIColor.lipstickRedColor()
   }

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      let title = self.buttonTitleForOption(self.option)
      self.setOptionButton.setTitle(title, forState: .Normal)
      self.iconImageView.image = AlarmOptionIconProvider.iconForOption(self.option)
      
      self.delegateDataSource = self.delegateDataSourceForOption(self.option)
   }
   
   override func viewDidAppear(animated: Bool)
   {
      self.tableView.flashScrollIndicators()
   }

   func dismissSelf()
   {
      // temporary
      self.navigationController?.popViewControllerAnimated(true)
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

extension AlarmOptionSettingsController: AlarmOptionSettingsControllerProtocol
{
   func configureWithAlarm(alarm: Alarm?, option: AlarmOption)
   {
      self.alarm = alarm
      self.option = option
   }
   
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
   
   private func buttonTitleForOption(option: AlarmOption) -> String
   {
      var title = ""
      switch (option)
      {
      case .Countdown:
         title = "set countdown display"
         break
      case .Date:
         title = "set date display"
         break
      case .Message:
         title = "set message"
         break
      case .Music:
         title = "set music"
         break
      case .Repeat:
         title = "set repeat"
         break
      case .Snooze:
         title = "set snooze"
         break
      case .Sound:
         title = "set sound"
         break
      case .Weather:
         title = "set weather display"
         break
         
      default:
         break
      }
      return title
   }
}
