//
//  AlarmOptionButton.swift
//  Modularm
//
//  Created by Gregory Klein on 4/13/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmOptionButton: UIButton
{
   var circleImageView: UIImageView?
   var activated: Bool = false

   @IBInspectable var activatedImage: UIImage?
   @IBInspectable var deactivatedImage: UIImage?

   override var highlighted: Bool {
      get {
         return super.highlighted
      }
      set {
         if newValue {
            self.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
         }
         else {
            self.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
         }
         super.highlighted = newValue
      }
   }

   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      if let image = self.imageView?.image
      {
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Highlighted)

         self.setupCircleImageView()
         self.addTarget(self, action: "toggleActivation", forControlEvents: UIControlEvents.TouchUpInside)
      }
   }

   func setupCircleImageView()
   {
      if let circleImage = UIImage(named: "bg-icn-plus-circle")
      {
         self.circleImageView = UIImageView(image: circleImage.imageWithRenderingMode(.AlwaysTemplate))
         self.circleImageView?.tintColor = UIColor(red: 190/255.0, green: 15/255.0, blue: 60/255.0, alpha: 1)

         self.insertSubview(self.circleImageView!, belowSubview: self.imageView!)
         self.circleImageView?.hidden = true
      }
   }

   override func layoutSubviews()
   {
      super.layoutSubviews()
      if let imageViewFrame = self.imageView?.frame
      {
         self.circleImageView?.frame = imageViewFrame
      }
   }

   func toggleActivation()
   {
      if self.activated
      {
         self.deactivate()
      }
      else
      {
         self.activate()
      }
   }

   func activate()
   {
      if !self.activated, let image = self.activatedImage
      {
         self.setTitleColor(UIColor.blackColor(), forState: .Normal)
         self.setImage(image, forState: .Normal)
         self.setImage(image, forState: .Highlighted)
         self.circleImageView?.hidden = false

         self.activated = true
      }
   }

   func deactivate()
   {
      if self.activated, let image = self.deactivatedImage
      {
         self.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Highlighted)
         self.circleImageView?.hidden = true

         self.activated = false
      }
   }
}
