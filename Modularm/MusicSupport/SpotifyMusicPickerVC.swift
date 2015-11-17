//
//  SpotifyMusicPickerVC.swift
//  Modularm
//
//  Created by Alex Hong on 8/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

protocol SpotifyMusicPickerVCDelegate : class{
   func spotifyMusicPickerDidPickTrack(track:SPTPartialTrack)
   func spotifyMusicPickerDidCancel()
}

class SpotifyMusicPickerVC:UINavigationController{
   weak var pickerDelegate:SpotifyMusicPickerVCDelegate?
   
   // MARK: - ARC Testing
   deinit{
      print("Deinit SpotifyMusicPickerVC")
   }
}