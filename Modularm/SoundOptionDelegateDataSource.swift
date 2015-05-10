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
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerProtocol, alarm: Alarm?)
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
      cell.accessoryType = indexPath.row == self.cellIndexForSoundString(self.soundModel!.basicSoundURL) ? .Checkmark : .None
      
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
