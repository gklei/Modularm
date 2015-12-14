//
//  MusicPlayerFactory.swift
//  Modularm
//
//  Created by Alex Hong on 9/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import AVFoundation

class IPodLibraryMusicPlayer:PAlarmMusicPlayer
{
   private let url:NSURL
   private var player:AVPlayer?
   
   init (url:NSURL)
   {
      self.url = url
   }
   
   // MARK: PAlaramMusicPlayer
   func play()
   {
      player = AVPlayer(URL: url)
      player?.play()
   }
   
   func stop()
   {
      player?.pause()
      player = nil
   }
}