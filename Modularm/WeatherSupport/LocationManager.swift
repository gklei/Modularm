//
//  LocationManager.swift
//  Modularm
//
//  Created by Alex Hong on 10/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

// This class monitors only significant location updates.
// Wrapper for CLLocationManager to retrieve location only one time.
// This class is used for onetime location fetch, so callback should not be accessed & changed.

import Foundation
import CoreLocation

typealias LocationCallback = (location:CLLocationCoordinate2D?, error:ErrorType?) -> ()

@objc class LocationManager:NSObject, CLLocationManagerDelegate{
   /*
   The reason for setting declare as var is to set to nil as quick as possible.
   */
   private var callback:LocationCallback
   private var locationManager:CLLocationManager = CLLocationManager()
   
   private init(callback:LocationCallback){
      self.callback = callback
      super.init()
   }
   
   // MARK: - Retrieve Location
   private func startLocationUpdate(){
      locationManager.delegate = self
      locationManager.distanceFilter = kCLDistanceFilterNone
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      
      let authStatus = CLLocationManager.authorizationStatus()
      switch(authStatus){
      case .AuthorizedAlways, .AuthorizedWhenInUse:
         locationManager.startUpdatingLocation()
      case .NotDetermined:
         locationManager.requestWhenInUseAuthorization()
      default:
         callback(location: nil, error: WeatherForecastError.LocationServiceDisabled)
      }
   }
   
   // Free all resources, so prevent double called.
   private func freeAllResources(){
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
   }
   
   // MARK: - CLLocationManagerDelegate
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
         locationManager.startUpdatingLocation()
      } else {
         callback(location: nil, error:WeatherForecastError.LocationServiceDisabled)
         freeAllResources()
      }
   }
   
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      callback(location: nil, error: error)
      freeAllResources()
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      callback(location: locations.last?.coordinate, error:nil)
      freeAllResources()
   }
   
   
   // MARK: - Class function
   // Usage: When calling this function, result of this should be hold strong
   // Unless it will be destroyed.
   class func retrieveLocation(callback:LocationCallback) -> Any{
      //To hold variable.
      var result:Any?
      //run synchronously on main thread because location update manager should run on main thread.
      GCDUtil.runOnMainSync{
         let lm = LocationManager(callback:callback)
         lm.startLocationUpdate()
         result = lm
      }
      return result
   }
}