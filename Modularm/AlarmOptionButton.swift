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
   @IBInspectable var activatedImage: UIImage?
   @IBInspectable var deactivatedImage: UIImage?
   var option: AlarmOption = .Unknown

   var circleImageView: UIImageView?

   private var _activated: Bool = false
   var activated: Bool {
      get {
         return self._activated
      }
      set {
         if self._activated != newValue
         {
            self._activated = newValue
            if newValue == true
            {
               self.activate()
            }
            else
            {
               self.deactivate()
            }
         }
      }
   }

   override var highlighted: Bool {
      get {
         return super.highlighted
      }
      set {
         self.backgroundColor = newValue ? UIColor.highlightedOptionButtonColor() : UIColor.normalOptionButtonColor()
         super.highlighted = newValue
      }
   }

   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      if let image = self.imageView?.image
      {
         self.setImage(image.templateImage, forState: .Normal)
         self.setImage(image.templateImage, forState: .Highlighted)

         self.setupCircleImageView()
         self.backgroundColor = UIColor.normalOptionButtonColor()
      }
   }

   func setupCircleImageView()
   {
      if let circleImage = UIImage(named: "bg-icn-plus-circle")
      {
         self.circleImageView = UIImageView(image: circleImage.templateImage)
         self.circleImageView?.tintColor = UIColor.lipstickRedColor()

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

   private func activate()
   {
      if let image = self.activatedImage
      {
         self.setTitleColor(UIColor.blackColor(), forState: .Normal)
         self.setImage(image, forState: .Normal)
         self.setImage(image, forState: .Highlighted)
         self.circleImageView?.hidden = false
      }
   }

   private func deactivate()
   {
      if let image = self.deactivatedImage
      {
         self.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
         self.setImage(image.templateImage, forState: .Normal)
         self.setImage(image.templateImage, forState: .Highlighted)
         self.circleImageView?.hidden = true
      }
   }
}
