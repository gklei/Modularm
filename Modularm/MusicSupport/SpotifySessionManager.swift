//
//  SpotifySessionManager.swift
//  Modularm
//
//  Created by Alex Hong on 7/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

typealias SpotifyAuthCallback = (success:Bool, error:ErrorType?) -> ()

enum SpotifyError:ErrorType, CustomStringConvertible{
   
   case NoSessionExists
   case UserCancelled
   
   var description:String{
      switch self {
      case .NoSessionExists:
         return "No previous session exists"
      case .UserCancelled:
         return "User cancelled Login"
      }
   }
}

@objc class SpotifySesionManager : NSObject {
   // MARK: - Singleton
   class var sharedInstance:SpotifySesionManager{
      struct SingletonWrapper{
         static let singleton = SpotifySesionManager()
      }
      return SingletonWrapper.singleton
   }
   
   private let spotifyStreamingController = SPTAudioStreamingController(clientId: kSpotifyClientId)
   
   // MARK: - Init
   override init(){
      super.init()
      
      let auth = SPTAuth.defaultInstance()
      auth.clientID = kSpotifyClientId
      auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope]
      auth.redirectURL = NSURL(string: kSpotifyCallbackURL)
      auth.tokenSwapURL = NSURL(string: kSpotifyTokenSwapServiceURL)
      auth.tokenRefreshURL = NSURL(string: kSpotifyTokenRefreshServiceURL)
      auth.sessionUserDefaultsKey = kSpotifySessionNSUserDefaultsKey
   }
   
   // MARK: - Session Manage
   func renewSession(callback:SpotifyAuthCallback) throws{
      let auth = SPTAuth.defaultInstance()
      guard let session = auth.session else {
         throw SpotifyError.NoSessionExists
      }
      
      guard !session.isValid() else {
         callback(success: true, error: nil)
         return
      }
      
      //session is invalid, so renew session
      auth.renewSession(session) { (error, session) -> Void in
         if (error == nil && session != nil) {
            auth.session = session
            callback(success: true, error: nil)
            return
         }
         callback(success: false, error: error)
      }
   }
   
   func hasSavedSession() -> Bool{
      return SPTAuth.defaultInstance().session != nil
   }
   
   func clearSession(){
      SPTAuth.defaultInstance().session = nil
   }
   
   // MARK: - Return Spotify player
   func createSpotifyPlayer(callback:(SPTAudioStreamingController?, ErrorType?)->()){
      do {
         try renewSession({ (success, error) -> () in
            guard success else {
               callback(nil, error)
               return
            }
            
            if !self.spotifyStreamingController.loggedIn {
               self.spotifyStreamingController.loginWithSession(SPTAuth.defaultInstance().session, callback: { (error) -> Void in
                  callback((error == nil) ? self.spotifyStreamingController : nil, error)
               })
            } else {
               callback(self.spotifyStreamingController, nil)
            }
         })
      }catch{
         
         callback(nil, error)
      }
   }
   
   // MARK: - Get user's playlistList
   func fetchUserPlaylist(handler:([SPTPartialPlaylist]?,ErrorType?)->()){
      do{
         try renewSession({ (success, error) -> () in
            guard success else{
               handler(nil, error)
               return
            }
            
            SPTPlaylistList .playlistsForUserWithSession(SPTAuth.defaultInstance().session, callback: { (error, obj) -> Void in
               handler((obj as? SPTPlaylistList)?.items as? [SPTPartialPlaylist], error)
            })
         })
      }catch{
         handler(nil, error)
      }
   }
   
   // MARK: - Get tracks of playlist List
   func fetchTrackOfPlaylist(playlist:SPTPartialPlaylist, handler:([SPTPartialTrack]?, ErrorType?) -> ()){
      do{
         try renewSession({ (success, error) -> () in
            guard success else{
               handler(nil, error)
               return
            }
            
            SPTPlaylistSnapshot.playlistWithURI(playlist.uri, session: SPTAuth.defaultInstance().session, callback: { (error, obj) -> Void in
               let snapshot = obj as? SPTPlaylistSnapshot
               handler((snapshot?.firstTrackPage?.items as? [SPTPartialTrack]), error)
            })
            
         })
      }catch{
         handler(nil, error)
      }
   }
}