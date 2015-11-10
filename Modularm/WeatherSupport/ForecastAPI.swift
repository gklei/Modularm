//
//  ForecastAPI.swift
//  Modularm
//
//  Created by Alex Hong on 10/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

// MARK: - Constants
private let kWeatherForecastAPIKey = "ceef665dc6534b474bcf4e8f1115d624"
private let kForecastURLEndPoint = "https://api.forecast.io/forecast/" + kWeatherForecastAPIKey + "/"

// This represent "current" key in response from forecast.io
private struct WeatherForecastResult{
   private let f_t:Double     //temperature in farenhite
   private let timeUTC:Int       //Time interval from 1970.1.1
   let summary:String //Summary string
   private let icon:String    //Icon String
   
   private init(_ json:JSON){
      f_t = json["temperature"].doubleValue
      timeUTC = json["time"].intValue
      summary = json["summary"].stringValue
      icon = json["icon"].stringValue
   }
}

extension NSDate : PWeatherForecastRequestParam{
   var time:NSDate{
      return self
   }
}

class WeatherForecastAPI {
   // MARK: - API for requesting WeatherForecast
   class func requestFor(param:PWeatherForecastRequestParam, callback:WeatherForecastCallback){
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
         do {
            let req = NSURLRequest(URL: try self.urlForRequest(param))
            NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, _, error) in
               guard error == nil && data != nil else {
                  GCDUtil.runOnMainAsync{
                     callback(result: nil, error: error)
                  }
                  return
               }
               //start parsing.
               let json = SwiftyJSON.JSON(data:data!)
               let result = WeatherForecastResult(json["currently"])
               GCDUtil.runOnMainSync{
                  callback(result: result, error: nil)
               }
            }.resume()
         }catch{
            GCDUtil.runOnMainAsync{
               callback(result: nil, error: error)
            }
         }
      }
   }
   
   // MARK: - Private functions
   // utility function for generate url for current forecast data.
   private class func urlForRequest(param:PWeatherForecastRequestParam) throws -> NSURL {
      let semaphore = dispatch_semaphore_create(0)
      var loc:CLLocationCoordinate2D?
      var err:ErrorType?
      
      //assign to some variable to prevent being released by arc.
      var retainer = [Any]()
      retainer.append(LocationManager.retrieveLocation { (location, error) -> () in
         loc = location
         err = error
         dispatch_semaphore_signal(semaphore)
      })
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
      retainer.removeAll()
      
      guard err == nil && loc != nil  else {
         throw err!
      }
      
      let time = (Int64)(param.time.timeIntervalSince1970)
      let extraQueryString = "?exclude=minutely,hourly,daily,alerts,flags"
      return NSURL(string: kForecastURLEndPoint + "\(loc!.latitude),\(loc!.longitude),\(time)" + extraQueryString) ?? NSURL()
   }
}

extension WeatherForecastResult:PWeatherForecastResult{
   var temperature:(f:Double, c:Double){
      //calculate celsius
      let c = (f_t - 32) * 5 / 9
      return (f_t, c)
   }
   
   var time:NSDate {
      return NSDate(timeIntervalSince1970: Double(timeUTC))
   }
   var summaryType:WeatherSummaryType {
      return WeatherSummaryType(icon)
   }
}