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
   private var hasEditedMessage = false
   private var messageModel: Message?
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
      if self.hasEditedMessage
      {
         let messageText = self.messageTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
         if count(messageText) > 0
         {
            self.messageModel?.text = messageText
            self.alarm?.message = self.messageModel!
            CoreDataStack.save()
         }
         else
         {
            self.alarm?.deleteOption(.Message)
         }
      }

      self.endEditingMessageAndDismissSelf()
   }
   
   @IBAction func cancelMessageButtonPressed()
   {
      self.endEditingMessageAndDismissSelf()
   }
   
   @IBAction func deleteMessageButtonPressed()
   {
      self.alarm?.deleteOption(self.option)
      self.endEditingMessageAndDismissSelf()
   }
}

extension AlarmMessageSettingsController: UITextViewDelegate
{
   func textViewDidBeginEditing(textView: UITextView)
   {
      self.hasEditedMessage = true
      var messageText = ""
      if let message = self.alarm?.message {
         messageText = message.text
      }
      textView.text = messageText
      textView.textColor = UIColor.blackColor()
   }
}
