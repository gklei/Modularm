//
//  WeatherSupport.swift
//  Modularm
//
//  Created by Alex Hong on 10/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation

// MARK: - Exported Protocols
protocol PWeatherForecastRequestParam{
   var time:NSDate { get }
}

protocol PWeatherForecastResult
{
   var readableTextSummary: String { get }
   var temperature:(f:Double, c:Double) { get }
   var time:NSDate { get }
   var summary:String { get }
   var summaryType:WeatherSummaryType { get }
}

enum WeatherSummaryType
{
   case ClearDay
   case ClearNight
   case Rain
   case Snow
   case Sleet
   case Wind
   case Fog
   case Cloudy
   case PartlyCloudyDay
   case PartlyCloudyNight
   case Hail
   case Thunderstorm
   case Tornado
   case Unknown
   
   init(_ raw:String)
   {
      if raw == "clear-day"{
         self = ClearDay
      }else if raw == "clear-night"{
         self = ClearNight
      }else if raw == "rain"{
         self = Rain
      }else if raw == "snow"{
         self = Sleet
      }else if raw == "sleet"{
         self = Sleet
      }else if raw == "wind"{
         self = Wind
      }else if raw == "fog"{
         self = Fog
      }else if raw == "cloudy"{
         self = Cloudy
      }else if raw == "partly-cloudy-day"{
         self = PartlyCloudyDay
      }else if raw == "partly-cloudy-night"{
         self = PartlyCloudyNight
      }else if raw == "hail"{
         self = Hail
      }else if raw == "thunderstorm"{
         self = Thunderstorm
      }else if raw == "tornado"{
         self = Tornado
      }else{
         self = Unknown
      }
   }
}

// Extension for getting resources
extension WeatherSummaryType
{
   var images:[UIImage] {
      var imageArray = [UIImage]()
      for name in self.imageNames
      {
         imageArray.append(UIImage(named: name)!)
      }
      return imageArray
   }
   
   var imageNames:[String] {
      switch self
      {
      case .ClearDay:
         return ["clear-day", "clear-day2"]
      case .ClearNight:
         return ["clear-night"]
      case .Cloudy:
         return ["cloudy"]
      case Rain:
         return ["rain"]
      case Snow:
         return ["snow"]
      case Sleet:
         return ["sleet"]
      case Wind:
         return ["wind", "wind2"]
      case Fog:
         return ["fog"]
      case PartlyCloudyDay:
         return ["partly-cloudy-day"]
      case PartlyCloudyNight:
         return ["partly-cloudy-night"]
      case Thunderstorm:
         return ["thunderstorm"]
      default:
         return []
      }
   }
   
   var icon:UIImage? {
      switch self
      {
      case .ClearDay:
         return UIImage(named: "clear-day-icn")
      case .ClearNight:
         return UIImage(named: "clear-night-icn")
      case .Cloudy:
         return UIImage(named: "cloudy-icn")
      case Rain:
         return UIImage(named: "rain-icn")
      case Snow:
         return UIImage(named: "snow-icn")
      case Sleet:
         return UIImage(named: "sleet-icn")
      case Wind:
         return UIImage(named: "wind-icn")
      case Fog:
         return UIImage(named: "fog-icn")
      case PartlyCloudyDay:
         return UIImage(named: "partly-cloudy-day-icn")
      case PartlyCloudyNight:
         return UIImage(named: "partly-cloudy-night-icn")
      case Thunderstorm:
         return UIImage(named: "thunderstorm-icn")
      default:
         return nil
      }
   }
}

typealias WeatherForecastCallback = (result:PWeatherForecastResult?, error:ErrorType?) -> ()

enum WeatherForecastError:ErrorType{
   case LocationServiceDisabled
}