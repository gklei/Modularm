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
   @IBOutlet weak var separatorView: UIView!
   weak var collectionView: UICollectionView?
   weak var alarm: Alarm?
   
   private var deleteButton: UIButton = UIButton.timelineCellDeleteButton()
   private var toggleButton: UIButton = UIButton.timelineCellToggleButton()
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
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
      self.deleteButton.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.contentView.bounds))
      self.deleteButton.addTarget(self, action: "deletePressed", forControlEvents: .TouchUpInside)
      
      self.toggleButton.frame = CGRectMake(CGRectGetWidth(self.deleteButton.frame), 0, 60, CGRectGetHeight(self.contentView.bounds))
      self.toggleButton.addTarget(self, action: "togglePressed", forControlEvents: .TouchUpInside)
      
      setupButtonContainer()
      setupScrollViewWithButtonContainer(self.buttonContainer)
   }
   
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.contentView.frame = self.bounds;
      self.scrollView.contentSize = CGSizeMake(self.contentView.frame.size.width + CGRectGetWidth(self.buttonContainer.frame), self.scrollView.frame.size.height);
      
      self.repositionButtons()
   }
   
   // MARK: - Setup
   private func setupScrollViewWithButtonContainer(container: UIView)
   {
      self.scrollView.tapDelegate = self
      self.scrollView.insertSubview(container, belowSubview: self.innerContentView)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOpen:", name: RevealCellDidOpenNotification, object: nil)
   }
   
   private func setupButtonContainer()
   {
      self.buttonContainer.frame = CGRectMake(0, 0, CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.toggleButton.frame), CGRectGetHeight(self.contentView.bounds))
      self.buttonContainer.addSubview(self.deleteButton)
      self.buttonContainer.addSubview(self.toggleButton)
   }
   
   // MARK: - Button Actions
   func togglePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      self.alarm?.active = false
      CoreDataStack.save()
   }
   
   func deletePressed()
   {
      self.scrollView.contentOffset = CGPointZero
      CoreDataStack.deleteObject(self.alarm)
      CoreDataStack.save()
   }
   
   @IBAction func activateButtonPressed()
   {
      self.alarm?.active = true
      CoreDataStack.save()
   }
   
   // MARK: - Private
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
   func configureWithAlarm(alarm: Alarm?)
   {
      self.alarm = alarm
      if let alarm = self.alarm
      {
         var viewModel = TimelineCellAlarmViewModel(alarm: alarm)
         
         self.innerContentView.backgroundColor = viewModel.innerContentViewBackgroundColor
         self.separatorView.backgroundColor = viewModel.separatorViewBackgroundColor
         self.label.attributedText = viewModel.attributedLabelText
         
         self.scrollView.scrollEnabled = alarm.active
         self.activateButton.hidden = alarm.active
      }
   }
   
   // MARK: - Notification-based Methods
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
}

extension TimelineCollectionViewCell: UIScrollViewDelegate
{
   func scrollViewDidScroll(scrollView: UIScrollView)
   {
      self.repositionButtons()
      
      // Don't allow scrolling right
      if scrollView.contentOffset.x < 0
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
      self.highlighted = !self.isOpen
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesCancelled touches: NSSet, withEvent event: UIEvent)
   {
      self.highlighted = false
   }
   
   func tapScrollView(scrollView: UIScrollView, touchesEnded touches: NSSet, withEvent event: UIEvent)
   {
      if let indexPath = self.collectionView?.indexPathForCell(self) where !self.isOpen
      {
         self.highlighted = false
         self.collectionView!.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
         self.collectionView!.delegate?.collectionView!(self.collectionView!, didSelectItemAtIndexPath: indexPath)
         
         NSNotificationCenter.defaultCenter().postNotificationName(RevealCellDidOpenNotification, object: self)
      }
      
   }
}
