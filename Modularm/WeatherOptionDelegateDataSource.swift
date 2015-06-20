//
//  WeatherOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class WeatherOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   // MARK - Instance Variables
   let backgroundPhotoOnOffSwitch = UISwitch()
   let locationAutoOnOffSwitch = UISwitch()
   
   var weatherModel: Weather?

   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.weatherModel = CoreDataStack.newModelWithOption(.Weather) as? Weather
      if let weather = alarm?.weather
      {
         self.weatherModel?.displayType = weather.displayType
         self.weatherModel?.autoLocationOn = weather.autoLocationOn
         self.weatherModel?.backgroundPhotoOn = weather.backgroundPhotoOn
      }
      
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Weather
      self.cellLabelDictionary = [0 :["34.4˚F slightly Rainy", "3˚C slightly Rainy", "slighty rainy"],
         1 : ["background photo", "location auto"]]
      
      self.backgroundPhotoOnOffSwitch.addTarget(self, action: "backgroundPhotoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
      self.backgroundPhotoOnOffSwitch.setOn(self.weatherModel!.backgroundPhotoOn, animated: false)
      
      self.locationAutoOnOffSwitch.addTarget(self, action: "locationAutoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
      self.locationAutoOnOffSwitch.setOn(self.weatherModel!.autoLocationOn, animated: false)
      
      self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: self.weatherModel)
   }
   
   override func saveSettings()
   {
      self.alarm?.weather = self.weatherModel!
   }

   override func cellWithIndexPath(indexPath: NSIndexPath, identifier: String) -> UITableViewCell
   {
      let cell = super.cellWithIndexPath(indexPath, identifier: identifier)
      if indexPath.section == 0
      {
         if let type = self.weatherDisplayTypeForCellIndex(indexPath.row), boldString = self.stringForDisplayType(type)
         {
            let mainLabel = self.cellLabelDictionary[indexPath.section]![indexPath.row]
            cell.textLabel?.attributedText = NSAttributedString(text: mainLabel, boldText: boldString)
         }
      }
      return cell
   }
}

// MARK: - Private
extension WeatherOptionDelegateDataSource
{
   func backgroundPhotoSwitchChanged(sender: UISwitch)
   {
      self.weatherModel!.backgroundPhotoOn = sender.on
   }

   func locationAutoSwitchChanged(sender: UISwitch)
   {
      self.weatherModel!.autoLocationOn = sender.on
   }

   private func stringForDisplayType(type: WeatherDisplayType) -> String?
   {
      var string: String?
      switch type
      {
      case .US:
         string = "US"
         break
      case .EU:
         string = "EU"
         break
      case .NoTemperature:
         break
      }
      return string
   }

   private func cellIndexForWeatherDisplayType(displayType: WeatherDisplayType) -> Int
   {
      var index = 0
      switch displayType
      {
      case .US:
         break
      case .EU:
         index = 1
         break
      case .NoTemperature:
         index = 2
         break
      }
      return index
   }
   
   private func weatherDisplayTypeForCellIndex(index: Int) -> WeatherDisplayType?
   {
      var displayType: WeatherDisplayType?
      switch index
      {
      case 0:
         displayType = .US
      case 1:
         displayType = .EU
      case 2:
         displayType = .NoTemperature
      default:
         break
      }
      return displayType
   }
}

// MARK: - UITableView Data Source
extension WeatherOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      if indexPath.section == 0
      {  
         var accessoryImageName = "ic_radial"
         if indexPath.row == self.cellIndexForWeatherDisplayType(self.weatherModel!.displayType) {
            accessoryImageName = "ic_radial_checked"
         }
         
         let accessoryImageView = UIImageView(image: UIImage(named:accessoryImageName)!)
         cell.accessoryView = accessoryImageView
      }
      else if indexPath.section == 1
      {
         let onOffSwitch = indexPath.row == 0 ? self.backgroundPhotoOnOffSwitch : self.locationAutoOnOffSwitch
         cell.accessoryView = onOffSwitch
      }
      
      return cell
   }
}

extension WeatherOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      if indexPath.section == 0
      {
         self.weatherModel!.displayType = self.weatherDisplayTypeForCellIndex(indexPath.row)!
         self.tableView.reloadData()
      }
   }
}
