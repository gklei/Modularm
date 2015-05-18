//
//  TimelineCollectionViewCell.swift
//  Modularm
//
//  Created by Klein, Greg on 5/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let RevealCellDidOpenNotification = "RevealCellDidOpenNotification"

class TimelineCollectionViewCell: UICollectionViewCell
{
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var innerContentView: UIView!
   @IBOutlet weak var scrollView: TapScrollView!
   @IBOutlet weak var activateButton: UIButton!
   weak var collectionView: UICollectionView?
   weak var alarm: Alarm?
   
   private var deleteButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
   private var toggleButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
   private lazy var dateFormatter: NSDateFormatter =
   {
      let formatter = NSDateFormatter()
      return formatter
      }()
   
   override var highlighted: Bool {
      get {
         return super.highlighted
      }
      set {
         if let alarm = self.alarm
         {
            if alarm.active == true
            {
               let whiteValue: CGFloat = newValue ? 0.15 : 0.09
               self.innerContentView.backgroundColor = UIColor(white: whiteValue, alpha: 1)
            }
         }
         super.highlighted = newValue
      }
   }
   
   // MARK: - Lifecycle
   override func awakeFromNib()
   {
      self.setupDeleteButton()
      self.setupToggleButton()
      self.setupButtonContainer()
      
      self.scrollView.tapDelegate = self
      self.scrollView.insertSubview(self.buttonContainer, belowSubview: self.innerContentView)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOpen:", name: RevealCellDidOpenNotification, object: nil)
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.contentView.frame = self.bounds;
      self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width + CGRectGetWidth(self.buttonContainer.frame), self.scrollView.frame.size.height);
      
      self.repositionButtons()
   }
   
   // MARK: - Private
   private func setupDeleteButton()
   {
      let title = NSAttributedString(string: "delete", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      self.deleteButton.setAttributedTitle(title, forState: .Normal)
      self.deleteButton.backgroundColor = UIColor.darkRedLipstickColor()
      self.deleteButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.contentView.bounds))
      
      self.deleteButton.addTarget(self, action: "deletePressed", forControlEvents: .TouchUpInside)
   }
   
   private func setupToggleButton()
   {
      let title = NSAttributedString(string: "toggle", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      self.toggleButton.setAttributedTitle(title, forState: .Normal)
      self.toggleButton.backgroundColor = UIColor.lipstickRedColor()
      self.toggleButton.frame = CGRectMake(CGRectGetWidth(self.deleteButton.frame), 0, 60, CGRectGetHeight(self.contentView.bounds))
      
      self.toggleButton.addTarget(self, action: "togglePressed", forControlEvents: .TouchUpInside)
   }
   
   func togglePressed()
   {
      UIView.animateWithDuration(0.15, animations: { () -> Void in
         self.scrollView.contentOffset = CGPointZero
         }, completion: { (finished: Bool) -> Void in
            
            if let alarm = self.alarm
            {
               alarm.active = !alarm.active
               CoreDataStack.save()
            }
      })
   }
   
   func deletePressed()
   {
      UIView.animateWithDuration(0.15, animations: { () -> Void in
         self.scrollView.contentOffset = CGPointZero
         self.alpha = 0
         }, completion: { (finished: Bool) -> Void in
            
            if let alarm = self.alarm
            {
               CoreDataStack.deleteObject(alarm)
               CoreDataStack.save()
            }
      })
   }
   
   @IBAction func activateButtonPressed()
   {
      self.alarm?.active = true
      CoreDataStack.save()
   }
   
   private func setupButtonContainer()
   {
      self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.toggleButton.frame), CGRectGetHeight(self.contentView.bounds))
      self.buttonContainer.addSubview(self.deleteButton)
      self.buttonContainer.addSubview(self.toggleButton)
   }
   
   private func repositionButtons()
   {
      var frame = self.buttonContainer.frame;
      frame.origin.x = self.contentView.frame.size.width - CGRectGetWidth(self.buttonContainer.frame) + self.scrollView.contentOffset.x;
      self.buttonContainer.frame = frame;
   }
   
   private func animateContenteOffset(position: CGPoint, withDuration duration: NSTimeInterval)
   {
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
         UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollView.contentOffset = position
         })
      })
   }
   
   // MARK: - Public
   func onOpen(notification: NSNotification)
   {
      if let object = notification.object as? TimelineCollectionViewCell
      {
         if object != self && self.isOpen
         {
            self.animateContenteOffset(CGPointZero, withDuration: 0.25)
         }
      }
   }
   
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
      if alarm?.active == false
      {
         self.scrollView.scrollEnabled = false
         self.activateButton.hidden = false
         self.innerContentView.backgroundColor = UIColor.normalOptionButtonColor()
      }
      else
      {
         self.scrollView.scrollEnabled = true
         self.activateButton.hidden = true
         self.innerContentView.backgroundColor = UIColor(white: 0.09, alpha: 1)
      }
      
      self.setupLabelWithAlarm(alarm)
   }
   
   private func setupLabelWithAlarm(alarm: Alarm?)
   {
      if let alarmEntry = alarm
      {
         self.dateFormatter.dateFormat = "hh:mm"
         var prettyAlarmDate = dateFormatter.stringFromDate(alarmEntry.fireDate)
         
         self.dateFormatter.dateFormat = "aa"
         var amOrPm = dateFormatter.stringFromDate(alarmEntry.fireDate).lowercaseString
         prettyAlarmDate += " \(amOrPm)"
         
         var alarmMessage = ""
         if alarmEntry.message != nil
         {
            alarmMessage = "  \(alarmEntry.message!.text)"
         }
         else
         {
            self.dateFormatter.dateFormat = "EEEE"
            alarmMessage = "  \(dateFormatter.stringFromDate(alarmEntry.fireDate))"
         }
         
         let textColor = alarmEntry.active ? UIColor.whiteColor() : UIColor.grayColor()
         var attributedText = NSAttributedString(boldText: prettyAlarmDate, text: alarmMessage, color: textColor)
         if alarm?.active == false
         {
            attributedText = NSAttributedString(lightText: "\(prettyAlarmDate)\(alarmMessage)", color: textColor)
         }
         self.label.attributedText = attributedText
      }
   }
}

extension TimelineCollectionViewCell: UIScrollViewDelegate
{
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      self.repositionButtons()
      
      // Don't allow scrolling right
      if scrollView.contentOffset.x < 0// || self.alarm?.active == false
      {
         scrollView.contentOffset = CGPointZero;
      }
      
      if scrollView.contentOffset.x >= CGRectGetWidth(self.buttonContainer.frame)
      {
         self.isOpen = true;
         NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
      }
      else
      {
         self.isOpen = false;
      }
   }
   
   func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
      var contentOffset = CGPointZero
      if velocity.x > 0
      {
         targetContentOffset.memory.x = CGRectGetWidth(self.buttonContainer.frame)
         contentOffset.x = CGRectGetWidth(self.buttonContainer.frame)
      }
      else
      {
         targetContentOffset.memory.x = 0;
      }
      self.animateContenteOffset(contentOffset, withDuration: 0.25)
   }
}

extension TimelineCollectionViewCell: TapScrollViewDelegate
{
   func tapScrollView(scrollView: UIScrollView, touchesBegan touches: NSSet, withEvent event: UIEvent)
   {
      if !isOpen
      {
         self.highlighted = true
      }
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   {
      self.highlighted = false
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
   {
      if (self.isOpen)
      {
         return;
      }
      
      if let cv = self.collectionView
      {
         let indexPath = cv.indexPathForCell(self)
         self.highlighted = false
         cv.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
         if let cvDelegate = cv.delegate
         {
            cvDelegate.collectionView!(cv, didSelectItemAtIndexPath: indexPath!)
         }
      }
      
      NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
   }
}
