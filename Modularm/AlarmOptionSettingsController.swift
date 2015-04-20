//
//  AlarmOptionSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionSettingsController: UIViewController
{
   @IBOutlet weak var setOptionButton: UIButton!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var iconImageView: UIImageView!
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
         
         let title = self.buttonTitleForOption(button.option)
         self.setOptionButton.setTitle(title, forState: .Normal)
         self.delegateDataSource = self.delegateDataSourceForOption(button.option)
      }
   }

   @IBAction func dismissSelf()
   {
      // temporary
      self.navigationController?.popViewControllerAnimated(true)
   }

   func configureWithAlarmOptionButton(optionButton: AlarmOptionButton)
   {
      self.optionButton = optionButton
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
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Date:
         delegateDataSource = DateOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Music:
         delegateDataSource = MusicOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Repeat:
         delegateDataSource = RepeatOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Snooze:
         delegateDataSource = SnoozeOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Sound:
         delegateDataSource = SoundOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Weather:
         delegateDataSource = WeatherOptionDelegateDataSource(tableView: self.tableView)
         break
         
      default:
         delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
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
