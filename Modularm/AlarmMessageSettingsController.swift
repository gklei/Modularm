//
//  AlarmMessageSettingsController.swift
//  Modularm
//
//  Created by Klein, Greg on 4/20/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class AlarmMessageSettingsController: OptionSettingsControllerBase
{
   @IBOutlet weak var messageTextView: UITextView!
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      self.setupMessageTextView()
   }
   
   private func setupMessageTextView()
   {
      self.messageTextView.delegate = self
      self.messageTextView.text = "e.g. Wake up!"
      self.messageTextView.textColor = UIColor.lightGrayColor()
      self.messageTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
   }
   
   private func endEditingMessageAndDismissSelf()
   {
      self.messageTextView.endEditing(true)
      self.dismissSelf()
   }
   
   @IBAction func setMessageButtonPressed()
   {
      self.endEditingMessageAndDismissSelf()
   }
   
   @IBAction func cancelMessageButtonPressed()
   {
      self.endEditingMessageAndDismissSelf()
   }
   
   @IBAction func deleteMessageButtonPressed()
   {
      self.endEditingMessageAndDismissSelf()
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
