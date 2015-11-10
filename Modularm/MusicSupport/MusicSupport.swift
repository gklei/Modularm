//
//  MusicSupport.swift
//  Modularm
//
//  Created by Alex Hong on 10/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//
/*
Exported classes & protocls & enum for music support
*/
import Foundation

// MARK: - Common Enums & Protocols
enum AlarmMusicType{
   case Spotify
   case iPodLibrary
}

protocol PAlarmMusic {
   var name:String {get}
   var musicType:AlarmMusicType {get}
   var url:NSURL {get}
}

// MARK: - Music Pick
typealias MusicPickerCallback = (PAlarmMusic?) -> ()

protocol PAlarmMusicPicker:class{
   func pickMusicFromVC(vc:UIViewController, callback:MusicPickerCallback)
}

class AlarmMusicPickerFactory{
   class func createMusicPicker(type:AlarmMusicType) -> PAlarmMusicPicker{
      switch type{
      case .Spotify:
         return SpotifyMusicPicker()
      case .iPodLibrary:
         return IPodLibraryMusicPicker()
      }
   }
}

// MARK: - Music Play
protocol PAlarmMusicPlayer:class{
   func play()
   func stop()
}

class AlarmMusicPlayerFactory{
   class func createMusicPlayer(music:PAlarmMusic) -> PAlarmMusicPlayer{
      switch (music.musicType){
      case .Spotify:
         return SpotifyMusicPlayer(url: music.url)
      case .iPodLibrary:
         return IPodLibraryMusicPlayer(url: music.url)
      }
   }
}

