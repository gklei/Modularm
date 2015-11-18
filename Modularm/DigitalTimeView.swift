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
   private let amOrPmLabel = UILabel.amOrPmLabel()
   
   private var _labels: [UILabel] {
      return [hourLabel, colonLabel, minuteLabel, amOrPmLabel]
   }
   
   // MARK: - Init
   required init?(coder aDecoder: NSCoder)
   {
      super.init(coder: aDecoder)
      setupLabels()
   }
   
   override init(frame: CGRect)
   {
      super.init(frame: frame)
      setupLabels()
   }
   
   // MARK: - Setup
   private func setupLabels()
   {
      hourLabel.text = "12"
      hourLabel.sizeToFit()
      addSubview(hourLabel)
      
      colonLabel.text = ":"
      colonLabel.sizeToFit()
      addSubview(colonLabel)
      
      minuteLabel.text = "12"
      minuteLabel.sizeToFit()
      addSubview(minuteLabel)
      
      amOrPmLabel.text = "am"
      amOrPmLabel.sizeToFit()
      addSubview(amOrPmLabel)
   }
   
   // MARK: - Lifecycle
   override func layoutSubviews()
   {
      super.layoutSubviews()
      
      colonLabel.center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
      
      let hourLabelWidth = hourLabel.bounds.width
      let hourLabelX: CGFloat = CGRectGetMinX(colonLabel.frame) - hourLabelWidth - 8.0
      let hourLabelY: CGFloat = colonLabel.center.y - hourLabel.bounds.height * 0.5
      
      hourLabel.frame.origin = CGPoint(x: hourLabelX, y: hourLabelY)
      
      let minuteLabelX = CGRectGetMaxX(colonLabel.frame)
      let minuteLabelY = colonLabel.center.y - minuteLabel.bounds.height * 0.5
      
      minuteLabel.frame.origin = CGPoint(x: minuteLabelX, y: minuteLabelY)
      
      let amPmLabelX = minuteLabel.frame.maxX + 6
      let amPmLabelY = minuteLabel.frame.minY + 14
      
      amOrPmLabel.frame.origin = CGPoint(x: amPmLabelX, y: amPmLabelY)
   }
   
   // MARK: - Public
   override func updateTimeWithAlarm(alarm: Alarm)
   {
      super.updateTimeWithAlarm(alarm)
      
      let date = alarm.fireDate
      hourLabel.text = TimeDisplayProvider.textForHourValue(date.hour)
      minuteLabel.text = TimeDisplayProvider.textForMinuteValue(date.minute)
      amOrPmLabel.text = date.hour < 12 ? "am" : "pm"
      amOrPmLabel.sizeToFit()
   }
   
   override func updateTimeWithHour(hour: Int, minute: Int)
   {
      super.updateTimeWithHour(hour, minute: minute)
      
      hourLabel.text = TimeDisplayProvider.textForHourValue(hour)
      minuteLabel.text = TimeDisplayProvider.textForMinuteValue(minute)
      amOrPmLabel.text = hour < 12 ? "am" : "pm"
      amOrPmLabel.sizeToFit()
   }
   
   override func updateColor(color: UIColor)
   {
      for label in _labels {
         label.textColor = color
      }
   }
}
