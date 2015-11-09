//
//  SpotifyTrackListVC.swift
//  Modularm
//
//  Created by Alex Hong on 9/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import WebImage

let kMusicPlaceholderImage = UIImage.imageWithImage(UIImage(named: "placeholder-music")!, scaledToSize: kImageSize)

//Extension for converting TimeInterval to duration
extension NSTimeInterval{
   var asDuration:String{
      let mins = (Int)(self / 60)
      let secs = (Int)(self % 60)
      let hours = mins / 60
      
      let formatter = NSNumberFormatter()
      formatter.minimumIntegerDigits = 2
      formatter.maximumFractionDigits = 0
      
      
      
      if (hours > 0) {
         return "\(hours):\(mins):\(formatter.stringFromNumber(secs) ?? "")"
      } else {
         return "\(mins):\(formatter.stringFromNumber(secs) ?? "")"
      }
   }
}

class SpotifyTrackListVC: UITableViewController {
   
   // MARK: - Property
   var playlist:SPTPartialPlaylist?          //Parameter from Playlist VC.
   var tracks:[SPTPartialTrack] = []
   
   var selectedRow = -1                      //Selected track no.
   
   var player:SPTAudioStreamingController?   //
   
   var doneButton:UIBarButtonItem!
   
   // MARK: - ViewController LifeCycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      initUI()
   }
   
   // MARK: - Functions
   func initUI(){
      self.title = playlist?.name
      guard let playlist = self.playlist else {
         return
      }
      
      //First try create player
      SpotifySesionManager.sharedInstance.createSpotifyPlayer { (player, error) -> () in
         self.player = player
         SpotifySesionManager.sharedInstance.fetchTrackOfPlaylist(playlist, handler: { (tracks, error) -> () in
            self.tracks = tracks ?? []
            self.tableView.reloadData()
         })
      }
      
      //Add Done Button
      doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonPressed:")
      doneButton.enabled = false //disable done button
      self.navigationItem.rightBarButtonItem = doneButton
   }

   @IBAction func doneButtonPressed(sender:AnyObject) {
      if selectedRow == -1 {
         return
      }
      
      let track = tracks[selectedRow]
      if let navVC = navigationController as? SpotifyMusicPickerVC {
         navVC.dismissViewControllerAnimated(true, completion: { () -> Void in
            navVC.pickerDelegate?.spotifyMusicPickerDidPickTrack(track)
         })
      }
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      //try stop player and logout
      self.player?.stop({(error) -> Void in
         
      })
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Table view data source
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tracks.count
   }
   
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("SpotifyTrackCellIdentifier", forIndexPath: indexPath)
      
      // Configure the cell...
      let track = tracks[indexPath.row]

      // Configure CheckMark
      cell.accessoryType = (indexPath.row == selectedRow) ? .Checkmark : .None
      cell.textLabel?.text = track.name
      cell.detailTextLabel?.text = track.duration.asDuration
      cell.imageView?.image = kMusicPlaceholderImage      
      if let imageURL = track.album?.smallestCover?.imageURL{
         SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: [], progress: nil, completed: { (image, _, _, _, _) -> Void in
            if image != nil{
               cell.imageView?.image = UIImage.imageWithImage(image, scaledToSize: kImageSize)
            }
         })
      }
      return cell
   }
   
   // MARK: - Table view delegate
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      if selectedRow >= 0 && selectedRow < tracks.count {
         checkAtRow(selectedRow, checked: false)
      }
      
      doneButton.enabled = true
      selectedRow = indexPath.row
      checkAtRow(indexPath.row)
      playTrackAtRow(selectedRow)
   }
   
   // MARK: - Utility
   private func checkAtRow(row:Int, checked:Bool = true){
      let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))
      cell?.accessoryType = checked ? .Checkmark : .None
   }
   
   // Play Track
   private func playTrackAtRow(row:Int){
      if row < 0 || row >= tracks.count{
         return
      }
      
      let track = tracks[row]
      player?.playURIs([track.playableUri], fromIndex: 0, callback: { (error) -> Void in
         
      })
   }
   
   // MARK: - ARC Testing
   deinit{
      print("Deinit TrackList VC")
   }
}
