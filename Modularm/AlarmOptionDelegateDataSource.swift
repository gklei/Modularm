//
//  AlarmOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionDelegateDataSource: NSObject
{
   // MARK: - Instance Variables
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
   internal var settingsControllerDelegate: AlarmOptionSettingsControllerProtocol
   internal var cellLabelDictionary: [Int : Array<String>]? = nil
   internal var tableView: UITableView
   internal var deleteSettingsButton: UIButton?

   // MARK: - Init
   init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      self.settingsControllerDelegate = delegate
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
      let cancelButton = UIButton.grayButtonWithTitle("Cancel")
      cancelButton.center = CGPointMake(CGRectGetWidth(cancelButton.frame)*0.5 + 16, 25)
      cancelButton.addTarget(self, action: "cancelButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)

      view.addSubview(cancelButton)
   }

   private func setupDeleteButtonWithSuperview(view: UIView)
   {
      self.deleteSettingsButton = UIButton.grayButtonWithTitle("Delete \(self.option.description.lowercaseString) settings")
      self.deleteSettingsButton!.center = CGPointMake(CGRectGetWidth(self.tableView.frame) - CGRectGetWidth(self.deleteSettingsButton!.frame)*0.5 - 16, 25)
      self.deleteSettingsButton!.addTarget(self, action: "cancelButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)

      view.addSubview(self.deleteSettingsButton!)
   }

   internal func cancelButtonPressed()
   {
      self.settingsControllerDelegate.cancelButtonPressed()
   }

   internal func deleteSettingsButtonPressed()
   {
      self.settingsControllerDelegate.deleteSettingsForOption(self.option)
   }

   internal func cellWithIndexPath(indexPath: NSIndexPath, identifier: String) -> UITableViewCell
   {
      let cell = self.tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
      cell.selectionStyle = .None
      cell.accessoryType = .None
      
      if let label = self.cellLabelDictionary?[indexPath.section]![indexPath.row]
      {
         cell.textLabel?.attributedText = NSAttributedString(text: label)
      }

      return cell
   }
}

// MARK: - UITableView Data Source
extension AlarmOptionDelegateDataSource: UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      var numberOfRows = 0
      if let dictionary = self.cellLabelDictionary
      {
         let labelArray = dictionary[section] as Array<String>?
         numberOfRows = labelArray!.count
      }
      return numberOfRows
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      var numberOfSections = 0
      if let dictionary = self.cellLabelDictionary
      {
         numberOfSections = dictionary.count
      }
      return numberOfSections
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
      return section == self.cellLabelDictionary!.count - 1 ? 0.01 : 50.0
   }
   
   func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
   {
      let view = UIView()
      view.backgroundColor = UIColor.normalOptionButtonColor()
      return view
   }
}
