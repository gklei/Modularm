//
//  SettingsTableViewDataSource.swift
//  Modularm
//
//  Created by Gregory Klein on 10/7/15.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

let kSettingsCellIdentifier = "settingsCellIdentifier"

class SettingsTableViewDataSource: NSObject
{
   private var tableView: UITableView!
   
   private let sectionTitleArray = ["Alarm Display Style", "Time Format"]
   private let cellTitleDictionary: [Int : Array<String>] = [0 : ["Analog", "Digital"], 1 : ["12 Hour", "24 Hour"]]
   
   init(tableView: UITableView)
   {
      super.init()
      self.tableView = tableView
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kSettingsCellIdentifier)
      
      self.tableView.tableFooterView = UIView(frame: CGRect.zero)
   }
}

extension SettingsTableViewDataSource : UITableViewDataSource
{
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return sectionTitleArray.count
   }
   
   func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
   {
      return sectionTitleArray[section]
   }
   
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 2
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier(kSettingsCellIdentifier)!
      
      cell.backgroundColor = UIColor.clearColor()
      
      if let font = UIFont(name: "HelveticaNeue-Light", size: 14)
      {
         cell.textLabel?.font = font
      }
      cell.textLabel?.textColor = UIColor.whiteColor()
      cell.textLabel?.text = cellTitleDictionary[indexPath.section]![indexPath.row]
      
      var accessoryImageName = "ic_radial"
      if indexPath.row == 0 {
         accessoryImageName = "ic_radial_checked"
      }
      
      let accessoryImageView = UIImageView(image: UIImage(named:accessoryImageName)!)
      cell.accessoryView = accessoryImageView
      return cell
   }
}

extension SettingsTableViewDataSource: UITableViewDelegate
{
   func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
   {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 35))
      let headerLabel = UILabel()
      headerLabel.textColor = UIColor.whiteColor()
      if let font = UIFont(name: "HelveticaNeue-Bold", size: 16)
      {
         headerLabel.font = font
      }
      headerLabel.text = sectionTitleArray[section]
      headerLabel.sizeToFit()
      
      headerView.addSubview(headerLabel)
      headerLabel.center = CGPoint(x: 12 + (headerLabel.bounds.width * 0.5), y: headerView.center.y)
      
      return headerView
   }
}
