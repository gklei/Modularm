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
   let _alarmSounds = AlarmSoundStore.sharedInstance.fetchAlarmSounds()

   private var _currentMusicPlayer: PAlarmMusicPlayer?
   private var _isPreviewingSound = false
   
   // MARK: - Init
   override init(tableView: UITableView, delegate: AlarmOptionSettingsControllerDelegate, alarm: Alarm?)
   {
      self.soundModel = CoreDataStack.newModelWithOption(.Sound) as? Sound
      if let sound = alarm?.sound
      {
         self.soundModel?.soundURL = sound.soundURL
         self.soundModel?.gradual = sound.gradual
      }
      
      super.init(tableView: tableView, delegate: delegate, alarm: alarm)
      self.option = .Sound
      
      var soundNames = [String]()
      for alarmSound in _alarmSounds {
         soundNames.append(alarmSound.name)
      }
      
      self.cellLabelDictionary = [0 : soundNames]
      self.settingsControllerDelegate.updateAuxViewWithOption(self.option, tempModel: self.soundModel)
      
      self.settingsControllerDelegate.updateCenterOptionButtonClosure { () -> () in
         
         self._isPreviewingSound = !self._isPreviewingSound
         if self._isPreviewingSound, let sound = self.soundModel?.alarmSound {
            self.startPlayingSound(sound)
         }
         else {
            self._currentMusicPlayer?.stop()
         }
         
         let title = self._isPreviewingSound ? "pause" : "play"
         self.settingsControllerDelegate.updateCenterOptionButtonTitle(title)
      }
      
      // we can't allow the user to delete the sound!
      self.deleteSettingsButton?.removeFromSuperview()
   }
   
   override func saveSettings()
   {
      _currentMusicPlayer?.stop()
      self.alarm?.sound = self.soundModel!
   }
   
   override func cancelSettings()
   {
      _currentMusicPlayer?.stop()
      super.cancelSettings()
   }
   
   private func startPlayingSound(sound: PAlarmSound)
   {
      self._currentMusicPlayer?.stop()
      self._currentMusicPlayer = AlarmMusicPlayerFactory.createMusicPlayer(sound)
      self._currentMusicPlayer?.play()
   }
   
   private func cellIndexForSoundString(string: String) -> Int
   {
      let labels: Array<String> = self.cellLabelDictionary[0]!
      return labels.indexOf(string)!
   }
}

extension SoundOptionDelegateDataSource
{
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
      
      var accessoryImageName = "ic_radial"
      if indexPath.row == self.cellIndexForSoundString(self.soundModel!.alarmSound!.name) {
         accessoryImageName = "ic_radial_checked"
      }
      
      let accessoryImageView = UIImageView(image: UIImage(named:accessoryImageName)!)
      cell.accessoryView = accessoryImageView
      
      return cell
   }
}

extension SoundOptionDelegateDataSource
{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      let alarmSound = _alarmSounds[indexPath.row]
      self.soundModel!.soundURL = alarmSound.url.path!
      self.tableView.reloadData()
      
      if _isPreviewingSound {
         startPlayingSound(alarmSound)
      }
   }
}
