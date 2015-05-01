//
//  WeatherOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import CoreData

class WeatherOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   // MARK - Instance Variables
   let backgroundPhotoOnOffSwitch = UISwitch()
   let locationAutoOnOffSwitch = UISwitch()
   
   var weatherModel: Weather

   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol)
   {
      let coreDataStack = CoreDataStack.defaultStack
      self.weatherModel = NSEntityDescription.insertNewObjectForEntityForName("Weather", inManagedObjectContext: coreDataStack.managedObjectContext!) as! Weather
      
      super.init(tableView: tableView, delegate: delegate)
      self.option = .Weather
      self.cellLabelDictionary = [0 :["34.4ºF slightly Rainy US", "3ºC slightly Rainy EU", "slighty Rainy int"],
         1 : ["Background Photo", "Location Auto"]]
      
      self.backgroundPhotoOnOffSwitch.setOn(self.weatherModel.backgroundPhotoOn, animated: false)
      self.backgroundPhotoOnOffSwitch.addTarget(self, action: "backgroundPhotoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
      
      self.locationAutoOnOffSwitch.setOn(self.weatherModel.autoLocationOn, animated: false)
      self.locationAutoOnOffSwitch.addTarget(self, action: "locationAutoSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
   }
}

// MARK: - Private
extension WeatherOptionDelegateDataSource
{
   func backgroundPhotoSwitchChanged(sender: UISwitch)
   {
      println("background photo on: \(sender.on)")
      self.weatherModel.backgroundPhotoOn = sender.on
   }

   func locationAutoSwitchChanged(sender: UISwitch)
   {
      println("location auto on: \(sender.on)")
      self.weatherModel.autoLocationOn = sender.on
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
         cell.accessoryType = indexPath.row == self.cellIndexForWeatherDisplayType(self.weatherModel.displayType) ? .Checkmark : .None
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
         self.weatherModel.displayType = self.weatherDisplayTypeForCellIndex(indexPath.row)!
         self.tableView.reloadData()
      }
   }
}
