//
//  SpotifyTokenRefreher.swift
//  Modularm
//
//  Created by Alex Hong on 7/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import SwiftHTTPServer

enum TokenServiceType{
    case Swap
    case Refresh
}

//extension for getting parameter
extension Dictionary{
    var urlEncoded:String{
        var parts:[String] = []
        for (key, value) in self {
            print ("\(value)".urlEncoded)
            parts.append("\(key)".urlEncoded + "=" + "\(value)".urlEncoded)
        }
        return parts.joinWithSeparator("&")
    }
}

extension String {
    var urlEncoded:String{
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()) ?? ""
    }
    
    var urlEncoded1:String{
        let a:NSString = self
        return a.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) ?? ""
    }
}

class SpotifyTokenRefresher {
    private let http = HttpServer()
    
    typealias handler = (TokenServiceType, HttpRequest) -> HttpResponse
    
    private init(){
        
    }
    
    // MARK: - Block for swap request.
    private let reqBlock:handler = { (type, request:HttpRequest) -> HttpResponse in
        
        //1. set auth header
        let cIdAndSecret = kSpotifyClientId + ":" + kSpotifyClientSecret
        let data = cIdAndSecret.dataUsingEncoding(NSASCIIStringEncoding)!
        let base64encoded = data.base64EncodedStringWithOptions([])
        let authHeader = "Basic " + base64encoded
        
        // Generate request
        let req = NSMutableURLRequest()
        req.URL = kSpotifyTokenServiceURL
        req.addValue(authHeader, forHTTPHeaderField: "Authorization")
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.HTTPMethod = "POST"
        
        let dict = request.parseForm()
        var param:[String:String] = [:]
        
        if type == .Swap {
            let auth_code = dict.filter{$0.0 == "code"}.last?.1 ?? ""
            param = ["grant_type":"authorization_code", "redirect_uri":kSpotifyCallbackURL, "code":auth_code]
        } else {
            let refresh_token = dict.filter{$0.0 == "refresh_token"}.last?.1 ?? ""
            param = ["grant_type":"refresh_token", "refresh_token":refresh_token]
        }
        
        let payload = param.urlEncoded
        let length = "\(payload.characters.count)"
        
        req.addValue(length, forHTTPHeaderField: "Content-Length")
        req.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Now ready to request
        var resp:HttpResponse = .NotFound
        
        // block code.
        let semaphore = dispatch_semaphore_create(0)
        NSURLSession.sharedSession().dataTaskWithRequest(req, completionHandler: { (data, response, error) -> Void in
            if (data != nil && error == nil){
                resp = .RAW(200, "OK", ["Content-Type":"text/html"], data!)
            }
            dispatch_semaphore_signal(semaphore)
        }).resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return resp
    }
    
    // MARK: - Private Singleton
    private static let singleton = SpotifyTokenRefresher()
    
    // MARK: - Start Token Service
    class func startTokenService(){
        do {
            singleton.http["/swap"] = { singleton.reqBlock(.Swap, $0) }
            singleton.http["/refresh"] = { singleton.reqBlock(.Refresh, $0) }
            
            try singleton.http.start(kSpotifyTokenSwapServicePort)
        }catch{}
    }
}

extension NSURLRequest{
    var curlRequestDumped:String{
        var curlStr = "curl -k -X \(HTTPMethod) --dump-header -"
        curlStr = allHTTPHeaderFields?.reduce(curlStr, combine: { (str, param) -> String in
            return str + " -H \"\(param.0): \(param.1)\""
        }) ?? curlStr
        
        if let body = HTTPBody{
            if let data = String(data: body, encoding: NSUTF8StringEncoding){
                curlStr = curlStr + " -d \"\(data)\""
            }
        }
        curlStr = curlStr + " \(URL?.absoluteString)"
        
        return curlStr
    }
}