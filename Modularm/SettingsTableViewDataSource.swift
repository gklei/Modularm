//
//  SettingsTableViewDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let kSettingsCellIdentifier = "settingsCellIdentifier"
let kDisplayStyleSectionIndex = 0
let kTimeFormatSectionIndex = 1
let kAnalogIndex = 0
let kDigitalIndex = 1
let kStandardTimeIndex = 0
let kMilitaryTimeIndex = 1

class SettingsTableViewDataSource: NSObject
{
   private var tableView: UITableView!
   
   private let sectionTitleArray = ["Alarm Display Style", "Time Format"]
   private let cellTitleDictionary: [Int : Array<String>] = [0 : ["Analog", "Digital"], 1 : ["12 Hour", "24 Hour"]]
   
   init(tableView: UITableView)
   {
      super.init()
      self.tableView = tableView
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kSettingsCellIdentifier)
      
      self.tableView.tableFooterView = UIView(frame: CGRect.zero)
   }
}

extension SettingsTableViewDataSource : UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return sectionTitleArray.count
   }
   
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
   {
      return sectionTitleArray[section]
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 2
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier(kSettingsCellIdentifier)!
      
      cell.backgroundColor = UIColor.clearColor()
      
      if let font = UIFont(name: "HelveticaNeue-Light", size: 14)
      {
         cell.textLabel?.font = font
      }
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.text = cellTitleDictionary[indexPath.section]![indexPath.row]
      
      var accessoryImageName = "ic_radial"
      switch indexPath.section {
      case kDisplayStyleSectionIndex:
         if AppSettingsManager.displayMode == displayModeForCellIndex(indexPath.row)
         {
            accessoryImageName = "ic_radial_checked"
         }
         break
      case kTimeFormatSectionIndex:
         if AppSettingsManager.timeFormat == timeFormatForCellIndex(indexPath.row)
         {
            accessoryImageName = "ic_radial_checked"
         }
         break
      default:
         break
      }
      
      let accessoryImageView = UIImageView(image: UIImage(named:accessoryImageName)!)
      cell.accessoryView = accessoryImageView
      cell.selectionStyle = .None
      
      return cell
   }
   
   private func displayModeForCellIndex(index: Int) -> DisplayMode
   {
      var mode: DisplayMode = .Analog
      switch index {
      case 0:
         mode = .Analog
         break
      case 1:
         mode = .Digital
         break
      default:
         break
      }
      return mode
   }
   
   private func timeFormatForCellIndex(index: Int) -> TimeFormat
   {
      var format: TimeFormat = .Standard
      switch index {
      case 0:
         format = .Standard
         break
      case 1:
         format = .Military
         break
      default:
         break
      }
      return format
   }
}

extension SettingsTableViewDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
   {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 35))
      let headerLabel = UILabel()
      headerLabel.textColor = UIColor.whiteColor()
      if let font = UIFont(name: "HelveticaNeue-Bold", size: 16)
      {
         headerLabel.font = font
      }
      headerLabel.text = sectionTitleArray[section]
      headerLabel.sizeToFit()
      
      headerView.addSubview(headerLabel)
      headerLabel.center = CGPoint(x: 12 + (headerLabel.bounds.width * 0.5), y: headerView.center.y)
      
      return headerView
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      switch indexPath.section {
      case kDisplayStyleSectionIndex:
         let mode = displayModeForCellIndex(indexPath.row)
         AppSettingsManager.setDisplayMode(mode)
         break
      case kTimeFormatSectionIndex:
         let format = timeFormatForCellIndex(indexPath.row)
         AppSettingsManager.setTimeFormat(format)
         break
      default:
         break
      }
      tableView.reloadData()
   }
}
