//
//  AlarmMusicPickerFactory.swift
//  Modularm
//
//  Created by Alex Hong on 8/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import MediaPlayer

enum AlarmMusicType{
   case Spotify
   case iPodLibrary
}

protocol PAlarmMusic {
   var name:String {get}
   var musicType:AlarmMusicType {get}
   var url:NSURL {get}
}

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

//Internal Enum for picking
enum PickedAlarmMusic{
   case Spotify(name:String, url:NSURL)
   case iPodLibrary(name:String, url:NSURL)
}

extension PickedAlarmMusic : PAlarmMusic{
   
   var name:String{
      switch(self){
      case .Spotify(let name, _):
         return name
      case .iPodLibrary(let name, _):
         return name
      }
   }
   
   var musicType:AlarmMusicType{
      switch(self){
      case .Spotify(_, _):
         return .Spotify
      case .iPodLibrary(_, _):
         return .iPodLibrary
      }
   }
   
   var url:NSURL{
      switch(self){
      case .Spotify(_, let url):
         return url
      case .iPodLibrary(_, let url):
         return url
      }
   }
}
