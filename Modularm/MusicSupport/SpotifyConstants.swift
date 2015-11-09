//
//  SpotifyConstants.swift
//  Modularm
//
//  Created by Alex Hong on 6/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// Spotify App Constants

// MARK: - Spotify app information
let kSpotifyClientId = "1212d1796d3c48d081e6293943dab8f5"
let kSpotifyClientSecret = "1b2494393f8443cdbe873a52c716fe0a"

// MARK: - Callback URL : Defined in Info.plist
let kSpotifyCallbackURL = "spotify-for-pvs-modularm://callback"

// MARK: - Token Service
let kSpotifyTokenSwapServicePort:in_port_t = 8090
let kSpotifyTokenSwapServiceURL = "http://localhost:\(kSpotifyTokenSwapServicePort)/swap"
let kSpotifyTokenRefreshServiceURL = "http://localhost:\(kSpotifyTokenSwapServicePort)/refresh"

// MARK: - NSUserDefaultsSaveKey
let kSpotifySessionNSUserDefaultsKey = "com.purevirtualstudios.modularm.SpotifySession"


// MARK: - Spotify Auth Account EndPoint
let kSpotifyTokenServiceURL = NSURL(string:"https://accounts.spotify.com/api/token")