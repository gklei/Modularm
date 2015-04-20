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
      }

      var delegateDataSource: AlarmOptionDelegateDataSource?
      switch (self.optionButton!.option)
      {
      case .Countdown:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Date:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Message:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Music:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Repeat:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Snooze:
         self.setOptionButton.setTitle("Set snooze", forState: .Normal)
         self.delegateDataSource = SnoozeOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Sound:
         self.delegateDataSource = AlarmOptionDelegateDataSource(tableView: self.tableView)
         break
      case .Weather:
         self.setOptionButton.setTitle("Set weather display", forState: .Normal)
         self.delegateDataSource = WeatherOptionDelegateDataSource(tableView: self.tableView)
         break
         
      default:
         break
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
