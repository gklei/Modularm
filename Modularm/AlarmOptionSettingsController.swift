//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol AlarmOptionSettingsControllerProtocol
{
   func configureWithOptionButton(button: AlarmOptionButton)
   func cancelButtonPressed()
   func deleteSettingsForOption(option: AlarmOption)
   func updateSetOptionButtonClosure(closure: (() -> ())?)
   func updateSetOptionButtonTitle(title: String)
   func resetSetOptionButtonTitle()
}

class AlarmOptionSettingsController: UIViewController
{
   @IBOutlet weak var setOptionButton: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var iconImageView: UIImageView!
   
   var setOptionButtonClosure: (() -> ())?
   var optionButton: AlarmOptionButton?
   var delegateDataSource: AlarmOptionDelegateDataSource?

   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.iconImageView.tintColor = UIColor.lipstickRedColor()
      self.tableView.tableFooterView = UIView(frame: CGRectZero)
   }

   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      if let button = self.optionButton
      {
         self.iconImageView.image = button.deactivatedImage?.templateImage
         
         let option = button.option
         let title = self.buttonTitleForOption(option)
         self.setOptionButton.setTitle(title, forState: .Normal)
         self.delegateDataSource = self.delegateDataSourceForOption(option)
      }
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
         self.dismissSelf()
      }
   }
}

extension AlarmOptionSettingsController: AlarmOptionSettingsControllerProtocol
{
   func configureWithOptionButton(optionButton: AlarmOptionButton)
   {
      self.optionButton = optionButton
   }
   
   func cancelButtonPressed()
   {
      self.dismissSelf()
   }
   
   func deleteSettingsForOption(option: AlarmOption)
   {
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
      if let option = self.optionButton?.option
      {
         let title = self.buttonTitleForOption(option)
         self.updateSetOptionButtonTitle(title)
      }
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
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Date:
         delegateDataSource = DateOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Music:
         delegateDataSource = MusicOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Repeat:
         delegateDataSource = RepeatOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Snooze:
         delegateDataSource = SnoozeOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Sound:
         delegateDataSource = SoundOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
      case .Weather:
         delegateDataSource = WeatherOptionDelegateDataSource(tableView: self.tableView, delegate: self)
         break
         
      default:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView, delegate: self)
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
         title = "Set countdown display"
         break
      case .Date:
         title = "Set date display"
         break
      case .Message:
         title = "Set message"
         break
      case .Music:
         title = "Set music"
         break
      case .Repeat:
         title = "Set repeat"
         break
      case .Snooze:
         title = "Set snooze"
         break
      case .Sound:
         title = "Set sound"
         break
      case .Weather:
         title = "Set weather display"
         break
         
      default:
         break
      }
      return title
   }
}
