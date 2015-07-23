//
//  DigitalTimeView.swift
//  Modularm
//
//  Created by Klein, Greg on 6/30/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

class DigitalTimeView: TimeView
{
   private let hourLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Left)
   private let colonLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Center)
   private let minuteLabel = UILabel.largeTimeDisplayLabelWithAlignment(.Right)
   
   // MARK: - Init
   required init(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      
      self.hourLabel.text = "12"
      self.hourLabel.sizeToFit()
      self.addSubview(self.hourLabel)
      
      self.colonLabel.text = ":"
      self.colonLabel.sizeToFit()
      self.addSubview(self.colonLabel)
      
      self.minuteLabel.text = "12"
      self.minuteLabel.sizeToFit()
      self.addSubview(self.minuteLabel)
   }
   
   // MARK: - Lifecycle
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      self.colonLabel.center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
      
      let hourLabelWidth = CGRectGetWidth(self.hourLabel.bounds)
      let hourLabelX: CGFloat = CGRectGetMinX(self.colonLabel.frame) - hourLabelWidth - 8.0
      let hourLabelY: CGFloat = self.colonLabel.center.y - CGRectGetHeight(self.hourLabel.bounds) * 0.5
      
      self.hourLabel.frame.origin = CGPoint(x: hourLabelX, y: hourLabelY)
      
      let minuteLabelX = CGRectGetMaxX(self.colonLabel.frame)
      let minuteLabelY = self.colonLabel.center.y - CGRectGetHeight(self.minuteLabel.bounds) * 0.5
      
      self.minuteLabel.frame.origin = CGPoint(x: minuteLabelX, y: minuteLabelY)
   }
   
   // MARK: - Public
   override func updateTimeWithAlarm(alarm: Alarm)
   {
      let date = alarm.fireDate
      self.hourLabel.text = TimeDisplayProvider.textForHourValue(date.hour)
      self.minuteLabel.text = TimeDisplayProvider.textForMinuteValue(date.minute)
   }
   
   override func updateTimeWithHour(hour: Int, minute: Int)
   {
      self.hourLabel.text = TimeDisplayProvider.textForHourValue(hour)
      self.minuteLabel.text = TimeDisplayProvider.textForMinuteValue(minute)
   }
}
