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
      let builder = AlarmOptionDelegateDataSourceBuilder(tableView: self.tableView, delegate: self, alarm: self.alarm)
      self.delegateDataSource = builder.buildWithOption(option)
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
      self.alarm?.deleteOption(option)
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
