//
//  AlarmMessageSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmMessageSettingsController: UIViewController
{
   @IBOutlet weak var iconImageView: UIImageView!
   @IBOutlet weak var messageTextView: UITextView!
   
   var optionButton: AlarmOptionButton?
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.iconImageView.tintColor = UIColor.lipstickRedColor()
      self.setupMessageTextView()
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      if let button = self.optionButton
      {
         self.iconImageView.image = button.deactivatedImage?.templateImage
      }
   }
   
   private func setupMessageTextView()
   {
      self.messageTextView.delegate = self
      self.messageTextView.text = "e.g. Wake up!"
      self.messageTextView.textColor = UIColor.lightGrayColor()
      self.messageTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
   }
   
   @IBAction func dismissSelf()
   {
      self.messageTextView.endEditing(true)
      self.navigationController?.popViewControllerAnimated(true)
   }
}

extension AlarmMessageSettingsController: AlarmOptionSettingsControllerProtocol
{
   func configureWithOptionButton(button: AlarmOptionButton)
   {
      self.optionButton = button
   }
   
   func cancelButtonPressed()
   {
   }
   
   func updateSetOptionButtonClosure(closure: (() -> ())?)
   {
   }
   
   func updateSetOptionButtonTitle(title: String)
   {
   }
   
   func resetSetOptionButtonTitle()
   {
   }
}

extension AlarmMessageSettingsController: UITextViewDelegate
{
   func textViewDidBeginEditing(textView: UITextView)
   {
      textView.text = ""
      textView.textColor = UIColor.blackColor()
   }
}
