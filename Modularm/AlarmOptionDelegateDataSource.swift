//
//  AlarmOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

protocol AlarmOptionSettingsControllerDelegate
{
   func cancelButtonPressed()
   func deleteSettingsButtonPressedWithOption(option: AlarmOption)
   func updateSetOptionButtonClosure(closure: (() -> ())?)
   func updateSetOptionButtonTitle(title: String)
   func resetSetOptionButtonTitle()
   func updateAuxViewWithOption(option: AlarmOption, tempModel: AnyObject?)
}

class AlarmOptionDelegateDataSource: NSObject
{
   // MARK: - Instance Variables
   internal var alarm: Alarm?
   private var _option: AlarmOption
   internal var option: AlarmOption {
      get {
         return _option
      }
      set {
         _option = newValue
         self.deleteSettingsButton?.removeFromSuperview()
         self.setupDeleteButtonWithSuperview(self.tableView.tableFooterView!)
      }
   }
   internal var settingsControllerDelegate: AlarmOptionSettingsControllerDelegate
   internal var cellLabelDictionary: [Int : Array<String>] = [:]
   internal var tableView: UITableView
   internal var deleteSettingsButton: UIButton?

   // MARK: - Init
   init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.settingsControllerDelegate = delegate
      self.alarm = alarm
      self.tableView = tableView
      self._option = .Unknown
      super.init()
      
      tableView.dataSource = self
      tableView.delegate = self
      tableView.backgroundColor = UIColor.normalOptionButtonColor()
      
      let view = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50))
      view.backgroundColor = UIColor.normalOptionButtonColor()
      
      self.setupDeleteButtonWithSuperview(view)
      self.setupCancelButtonWithSuperview(view)
      
      tableView.tableFooterView = view
   }
}

// MARK: - Private & Internal
extension AlarmOptionDelegateDataSource
{
   private func setupCancelButtonWithSuperview(view: UIView)
   {
      let cancelButton = UIButton.grayButtonWithTitle("cancel")
      cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)
      cancelButton.addTarget(self, action: "cancelSettings", forControlEvents: UIControlEvents.TouchUpInside)

      view.addSubview(cancelButton)
   }

   private func setupDeleteButtonWithSuperview(view: UIView)
   {
      self.deleteSettingsButton = UIButton.grayButtonWithTitle("delete \(self.option.description.lowercaseString) settings")
      self.deleteSettingsButton!.center = CGPointMake(CGRectGetWidth(self.tableView.frame) - CGRectGetWidth(self.deleteSettingsButton!.frame)*0.5 - 24, 25)
      self.deleteSettingsButton!.addTarget(self, action: "deleteSettings", forControlEvents: UIControlEvents.TouchUpInside)

      view.addSubview(self.deleteSettingsButton!)
   }
   
   internal func cancelSettings()
   {
      self.settingsControllerDelegate.cancelButtonPressed()
   }
   
   internal func deleteSettings()
   {
      self.settingsControllerDelegate.deleteSettingsButtonPressedWithOption(self.option)
   }

   internal func cellWithIndexPath(indexPath: NSIndexPath, identifier: String) -> UITableViewCell
   {
      let cell = self.tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
      cell.selectionStyle = .None
      cell.accessoryType = .None
      
      let label = self.cellLabelDictionary[indexPath.section]![indexPath.row]
      cell.textLabel?.attributedText = NSAttributedString(text: label)

      return cell
   }
   
   func saveSettings()
   {
   }
}

// MARK: - UITableView Data Source
extension AlarmOptionDelegateDataSource: UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      var numberOfRows = 0
      let labelArray = self.cellLabelDictionary[section] as Array<String>?
      numberOfRows = labelArray!.count
      
      return numberOfRows
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return self.cellLabelDictionary.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      return self.cellWithIndexPath(indexPath, identifier: "cell")
   }
}

// MARK: - UITableView Delegate
extension AlarmOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
   {
      let isLastSection = section == self.cellLabelDictionary.count - 1;
      
      // return 0.01 for the last section because we already set up a footer view for the
      // cancel and delete button
      return isLastSection ? 0.01 : 50.0
   }
   
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()
      return view
   }
}
