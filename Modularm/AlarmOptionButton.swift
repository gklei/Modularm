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
   let activatedTintColor = UIColor.whiteColor()
   let deactivatedTintColor = UIColor.blackColor()

   let activatedAlphaValue: CGFloat = 1
   let deactivatedAlphaValue: CGFloat = 0.3

   var circleImageView: UIImageView?
   var activated: Bool = false

   @IBInspectable var activatedImage: UIImage?
   @IBInspectable var deactivatedImage: UIImage?

   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)

      if let image = self.imageView?.image
      {
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
         self.tintColor = self.deactivatedTintColor

         self.setupCircleImageView()
         self.addTarget(self, action: "toggleActivation", forControlEvents: UIControlEvents.TouchUpInside)
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
      self.activated = !self.activated
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

   func activate()
   {
      if let image = self.activatedImage
      {
         self.setImage(image, forState: .Normal)
         self.circleImageView?.hidden = false
         self.tintColor = self.activatedTintColor
         self.alpha = self.activatedAlphaValue
      }
   }

   func deactivate()
   {
      if let image = self.deactivatedImage
      {
         self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
         self.circleImageView?.hidden = true
         self.tintColor = self.deactivatedTintColor
         self.alpha = self.deactivatedAlphaValue
      }
   }
}
