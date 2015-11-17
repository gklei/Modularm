//
//  MusicPlayerFactory.swift
//  Modularm
//
//  Created by Alex Hong on 9/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation

class IPodLibraryMusicPlayer:PAlarmMusicPlayer{
   private let url:NSURL
   private var player:AVPlayer?
   
   init (url:NSURL){
      self.url = url
   }
   
   // MARK: PAlaramMusicPlayer
   func play() {
      player = AVPlayer(URL: url)
      player?.play()
   }
   
   func stop(){
      player?.pause()
      player = nil
   }
}

class SpotifyMusicPlayer:PAlarmMusicPlayer{
   private let url:NSURL
   private var player:SPTAudioStreamingController?
   private var isStopped:Bool = false
   
   init (url:NSURL){
      self.url = url
   }
   
   // MARK: PAlaramMusicPlayer
   func play() {
      //fetch logged-in spotify shared music player and start play.
      SpotifySesionManager.sharedInstance.createSpotifyPlayer { (player, error) -> () in
         self.play_(player)
      }
   }
   
   func play_(player:SPTAudioStreamingController?){
      //if this is already stopped, return.
      if isStopped {
         return
      }
      self.player = player
      player?.playURIs([self.url], fromIndex: 0, callback: { (error) -> Void in
         
      })
   }
   
   func stop(){
      isStopped = true
      //stop spotify player
      player?.stop({ (error) -> Void in
         
      })
   }
}




