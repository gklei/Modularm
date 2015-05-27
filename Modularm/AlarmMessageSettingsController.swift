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
   var messageModel: Message?
   @IBOutlet weak var messageTextView: UITextView!

   // MARK: Lifecycle
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)

      self.messageModel = CoreDataStack.newModelWithOption(.Message) as? Message
      if let message = self.alarm?.message {
         self.messageModel?.text = message.text
      }

      self.setupMessageTextView()
   }
   
   private func setupMessageTextView()
   {
      self.messageTextView.delegate = self

      var messageText = "e.g. Wake up!"
      if let message = self.alarm?.message {
         messageText = message.text
      }

      self.messageTextView.text = messageText
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
      self.messageModel?.text = self.messageTextView.text
      self.alarm?.message = self.messageModel!
      CoreDataStack.save()

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
      var messageText = ""
      if let message = self.alarm?.message {
         messageText = message.text
      }
      textView.text = messageText
      textView.textColor = UIColor.blackColor()
   }
}
