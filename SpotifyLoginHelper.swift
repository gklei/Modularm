//
//  SpotifyLoginHelper.swift
//  Modularm
//
//  Created by Alex Hong on 7/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import Foundation


/*
General Usage

So helper should be held strong as property of using view controller (or instance)
After finished using, assign helper property to nil

var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
while (topVC?.presentedViewController != nil){
topVC = topVC?.presentedViewController
}

self.helper = SpotifyLoginHelper(callback: {[weak self] success, error in
print("LoggedIn \(success), \(error)")
self?.helper = nil
})
self.helper?.loginFromVC(topVC!)
*/



@objc class SpotifyLoginHelper :NSObject, SPTAuthViewDelegate{
   let callback:SpotifyAuthCallback
   var authVC:SPTAuthViewController?
   
   init(callback:SpotifyAuthCallback){
      self.callback = callback
      super.init()
   }
   
   func loginFromVC(vc:UIViewController){
      do {
         try SpotifySesionManager.sharedInstance.renewSession(callback)
      }catch SpotifyError.NoSessionExists{
         showAuthVC(vc)
      }catch{
         //Nothing is thrown
      }
   }
   
   private func showAuthVC(vc:UIViewController){
      let authVC = SPTAuthViewController.authenticationViewController()
      authVC.delegate = self
      authVC.modalPresentationStyle = .OverCurrentContext
      authVC.modalTransitionStyle = .CrossDissolve
      
      vc.modalPresentationStyle = .CurrentContext
      vc.definesPresentationContext = true
      
      vc.presentViewController(authVC, animated: true, completion: nil)
      
      //assign authVC to retain it.
      self.authVC = authVC
   }
   
   // MARK: - SPTAuthViewDelegate
   func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
      self.authVC = nil
      callback(success: false, error: SpotifyError.UserCancelled)
   }
   
   func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
      //error handling.
      self.authVC = nil
      callback(success: false, error: error)
   }
   
   func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
      self.authVC = nil
      //assign session
      SPTAuth.defaultInstance().session = session
      callback(success: true, error: nil)
   }
}