//
//  MediaItemPicker.swift
//  Modularm
//
//  Created by Alex Hong on 8/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

// This file is wrapper for MPMediaPickerController

import Foundation
import MediaPlayer

class IPodLibraryMusicPicker:NSObject, MPMediaPickerControllerDelegate, PAlarmMusicPicker {
   private var _picker:MPMediaPickerController?
   private var _callback:MusicPickerCallback?
   
   override init(){
      super.init()
   }
   
   // MARK: PAlarmMusicPicker
   func pickMusicFromVC(vc:UIViewController, callback:MusicPickerCallback){
      _callback = callback
      _picker = MPMediaPickerController(mediaTypes: .Music)
      _picker?.delegate = self
      _picker?.allowsPickingMultipleItems = false
      vc.presentViewController(_picker!, animated: true, completion: nil)
   }
   
   // MARK: - MPMediaPickerController delegate
   func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
      _picker?.dismissViewControllerAnimated(true, completion: nil)
      defer {
         _callback = nil
         _picker = nil
      }
      
      guard let item = mediaItemCollection.items.last else {
         _callback?(nil)
         return
      }
      _callback?(PickedAlarmMusic.iPodLibrary(name:item.title ?? "Unnamed", url:item.assetURL ?? NSURL()))
   }
   
   func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
      _picker?.dismissViewControllerAnimated(true, completion: nil)
      _callback?(nil)
      _callback = nil
      _picker = nil
   }
}