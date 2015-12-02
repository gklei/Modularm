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
   var centerOptionButtonClosure: (() -> ())?
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
   
   @IBAction func centerOptionButtonPressed()
   {
      if let closure = self.centerOptionButtonClosure {
         closure()
      }
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
   
   func updateCenterOptionButtonClosure(closure: (() -> ())?)
   {
      self.centerOptionButtonClosure = closure
   }
   
   func updateSetOptionButtonTitle(title: String)
   {
      UIView.setAnimationsEnabled(false)
      self.setOptionButton.setTitle(title, forState: .Normal)
      self.setOptionButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true);
   }
   
   func updateCenterOptionButtonTitle(title: String)
   {
      UIView.setAnimationsEnabled(false)
      self.centerOptionButton.setTitle(title, forState: .Normal)
      self.centerOptionButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true);
   }
   
   func resetSetOptionButtonTitle()
   {
      let title = self.titleForOption(self.option)
      self.updateSetOptionButtonTitle(title)
   }
   
   func resetCenterOptionButtonTitle()
   {
      let title = self.centerButtonTitleForOption(self.option)
      self.updateCenterOptionButtonTitle(title)
   }
   
   func updateAuxViewWithOption(option: AlarmOption, tempModel: AlarmOptionModelProtocol?)
   {
      if let auxView = self.auxiliaryView, title = tempModel?.humanReadableString()
      {
         self.resetAuxView()
         
         let label = UILabel.timeIntervalLabelWithText(title)
         label.center = CGPoint(x: auxView.bounds.midX, y: auxView.bounds.midY)
         label.frame = auxView.bounds.insetBy(dx: 40, dy: 6)
         label.textAlignment = .Center
         auxView.addSubview(label)
      }
   }
   
   func vcForPresenting() -> UIViewController?
   {
      return viewControllerForPresenting
   }
   
   private func resetAuxView()
   {
      if let auxView = self.auxiliaryView
      {
         for subview in auxView.subviews
         {
            subview.removeFromSuperview()
         }
      }
   }
}
