//
//  SoundOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class SoundOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   var soundModel: Sound?
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.soundModel = CoreDataStack.newModelWithOption(.Sound) as? Sound
      if let sound = alarm?.sound
      {
         self.soundModel?.basicSoundURL = sound.basicSoundURL
         self.soundModel?.shouldVibrate = sound.shouldVibrate
      }
      
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Sound
      self.cellLabelDictionary = [0 : ["Basic", "Silent (Vibration)", "Classic", "John Lord", "Jimmy Hendrix", "George Harrison", "Cliff", "Drama", "Beach Morning"]]
      self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: self.soundModel)
   }
   
   override func saveSettings() {
      self.alarm?.sound = self.soundModel!
   }
   
   private func cellIndexForSoundString(string: String) -> Int
   {
      let labels: Array<String> = self.cellLabelDictionary[0]!
      return find(labels, string)!
   }
}

extension SoundOptionDelegateDataSource: UITableViewDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      var accessoryImageName = "ic_radial"
      if indexPath.row == self.cellIndexForSoundString(self.soundModel!.basicSoundURL) {
         accessoryImageName = "ic_radial_checked"
      }
      
      let accessoryImageView = UIImageView(image: UIImage(named:accessoryImageName)!)
      cell.accessoryView = accessoryImageView
      
      return cell
   }
}

extension SoundOptionDelegateDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      self.soundModel!.basicSoundURL = self.cellLabelDictionary[0]![indexPath.row]
      self.tableView.reloadData()
   }
}
