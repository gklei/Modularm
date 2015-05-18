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
   weak var collectionView: UICollectionView?
   
   private var deleteButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
   private var toggleButton: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
   private var buttonContainer = UIView()
   private var isOpen: Bool = false
   
   override var highlighted: Bool {
      get {
         return super.highlighted
      }
      set {
         let whiteValue: CGFloat = newValue ? 0.15 : 0.09
         self.innerContentView.backgroundColor = UIColor(white: whiteValue, alpha: 1)
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
   }
   
   private func setupToggleButton()
   {
      let title = NSAttributedString(string: "toggle", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 14)!, NSForegroundColorAttributeName : UIColor.whiteColor()])
      self.toggleButton.setAttributedTitle(title, forState: .Normal)
      self.toggleButton.backgroundColor = UIColor.lipstickRedColor()
      self.toggleButton.frame = CGRectMake(CGRectGetWidth(self.deleteButton.frame), 0, 60, CGRectGetHeight(self.contentView.bounds))
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
   
   // MARK: - Public
   func onOpen(notification: NSNotification)
   {
      if let object = notification.object as? TimelineCollectionViewCell
      {
         if object != self && self.isOpen
         {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               UIView.animateWithDuration(0.25, animations: { () -> Void in
                  self.scrollView.contentOffset = CGPointZero
               })
            })
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
      if velocity.x > 0
      {
         targetContentOffset.memory.x = CGRectGetWidth(self.buttonContainer.frame);
      }
      else
      {
         targetContentOffset.memory.x = 0;
      }
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
