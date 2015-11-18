//
//  SettingsTableViewDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let kSettingsCellIdentifier = "settingsCellIdentifier"
let kTimeFormatSectionIndex = 0
let kClockDisplayStyleSectionIndex = 1
let kDateDisplaySectionIndex = 2
let kWeatherDisplaySectionIndex = 3

class SettingsTableViewDataSource: NSObject
{
   private var tableView: UITableView!
   
   private let sectionTitleArray = ["Time Format", "Alarm Display", "Date Display", "Weather Display"]
   private let cellTitleDictionary: [Int : Array<String>] = [
      kTimeFormatSectionIndex : ["12 Hour", "24 Hour"],
      kClockDisplayStyleSectionIndex : ["Analog", "Digital"],
      kDateDisplaySectionIndex : ["Tuesday 04/10", "10.04 Tuesday", "Tuesday"],
      kWeatherDisplaySectionIndex : ["37.4˚ F partly cloudy", "3˚ C partly cloudy", "partly cloudy"]
   ]
   
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
      return cellTitleDictionary[section]!.count
   }
   
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
   {
      return sectionTitleArray[section]
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return sectionTitleArray.count
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
      case kClockDisplayStyleSectionIndex:
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
      case kWeatherDisplaySectionIndex:
         if AppSettingsManager.weatherDisplay == weatherDisplayTypeForCellIndex(indexPath.row)
         {
            accessoryImageName = "ic_radial_checked"
         }
         break
      case kDateDisplaySectionIndex:
         if AppSettingsManager.dateDisplay == dateDisplayTypeForCellIndex(indexPath.row)
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
      return DisplayMode(rawValue: index) ?? .Analog
   }
   
   private func timeFormatForCellIndex(index: Int) -> TimeFormat
   {
      return TimeFormat(rawValue: index) ?? .Standard
   }
   
   private func weatherDisplayTypeForCellIndex(index: Int) -> WeatherDisplayType
   {
      return WeatherDisplayType(rawValue: Int16(index)) ?? .US
   }
   
   private func dateDisplayTypeForCellIndex(index: Int) -> DateDisplayType
   {
      return DateDisplayType(rawValue: Int16(index)) ?? .US
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
      case kClockDisplayStyleSectionIndex:
         let mode = displayModeForCellIndex(indexPath.row)
         AppSettingsManager.setDisplayMode(mode)
         break
      case kTimeFormatSectionIndex:
         let format = timeFormatForCellIndex(indexPath.row)
         AppSettingsManager.setTimeFormat(format)
         break
      case kDateDisplaySectionIndex:
         let displayType = dateDisplayTypeForCellIndex(indexPath.row)
         AppSettingsManager.setDateDisplay(displayType)
         break
      case kWeatherDisplaySectionIndex:
         let displayType = weatherDisplayTypeForCellIndex(indexPath.row)
         AppSettingsManager.setWeatherDisplay(displayType)
      default:
         break
      }
      tableView.reloadData()
   }
}
