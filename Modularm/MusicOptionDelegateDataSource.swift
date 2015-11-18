//
//  MusicOptionDelegateDataSource.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class MusicOptionDelegateDataSource: AlarmOptionDelegateDataSource
{
   private var musicPicker: PAlarmMusicPicker?
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Music
      self.cellLabelDictionary = [0 :["itunes", "spotify"]]
      self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: nil)
   }
}

// MARK: - Private
extension MusicOptionDelegateDataSource
{
   func itunesSwitchChanged(sender: UISwitch)
   {
      musicPicker = AlarmMusicPickerFactory.createMusicPicker(.iPodLibrary)
      musicPicker?.pickMusicFromVC(settingsControllerDelegate.vcForPresenting()!, callback: { (music) -> () in
         //Process retrieved music here.
         self.musicPicker = nil
      })
   }

   func spotifySwitchChanged(sender: UISwitch)
   {
      musicPicker = AlarmMusicPickerFactory.createMusicPicker(.Spotify)
      musicPicker?.pickMusicFromVC(settingsControllerDelegate.vcForPresenting()!, callback: { (music) -> () in
         //Process retrieved music here.
         self.musicPicker = nil
      })
   }
}

// MARK: - UITableView Delegate
extension MusicOptionDelegateDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      let switchView = UISwitch()
      switchView.setOn(false, animated: false)
      
      var selectorString: Selector? = nil
      switch (indexPath.row)
      {
      case 0:
         selectorString = "itunesSwitchChanged:"
         break;
      case 1:
         selectorString = "spotifySwitchChanged:"
         break;
      default:
         break;
      }
      
      if let selector = selectorString
      {
         switchView.addTarget(self, action: selector, forControlEvents: UIControlEvents.ValueChanged)
         cell.accessoryView = switchView
      }
      
      return cell
   }
}
