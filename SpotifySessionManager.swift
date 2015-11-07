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
    
    // MARK: - Renew session
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
    
    // MARK: - Return Spotify player
    func createSpotifyPlayer(callback:(SPTAudioStreamingController?, ErrorType?)->()){
        do {
            try renewSession({ (success, error) -> () in
                guard success else {
                    callback(nil, error)
                    return
                }
                
                // session is already exist and valid here. so try login player.
                let player = SPTAudioStreamingController(clientId: kSpotifyClientId)
                player.loginWithSession(SPTAuth.defaultInstance().session, callback: { (error) -> Void in
                    callback((error == nil) ? player : nil, error)
                })
            })
        }catch{
            callback(nil, error)
        }
    }
}