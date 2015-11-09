//
//  SpotifyMusicPicker.swift
//  Modularm
//
//  Created by Alex Hong on 8/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

let kSpotifyPickerUIStoryboardId = "SpotifyPickerUI"
class SpotifyMusicPicker:PAlarmMusicPicker, SpotifyMusicPickerVCDelegate{
   
   private var _callback:MusicPickerCallback?
   private var _picker:SpotifyMusicPickerVC?
   
   func pickMusicFromVC(vc:UIViewController, callback:MusicPickerCallback){
      guard let picker = UIStoryboard(name: kSpotifyPickerUIStoryboardId, bundle: nil).instantiateInitialViewController() as? SpotifyMusicPickerVC else{
         callback(nil)
         return
      }
      _callback = callback
      picker.pickerDelegate = self
      _picker = picker
      vc.presentViewController(picker, animated: true, completion: nil)

   }
   
   // MARK: - SpotifyMusicPickerVC Delegate
   func spotifyMusicPickerDidPickTrack(track:SPTPartialTrack){
      _callback?(PickedAlarmMusic.Spotify(name:track.name, url:track.playableUri))
      _picker = nil
   }
   
   func spotifyMusicPickerDidCancel(){
      _callback?(nil)
      _callback = nil
      _picker = nil
   }
}