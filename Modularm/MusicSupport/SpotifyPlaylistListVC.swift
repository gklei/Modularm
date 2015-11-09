//
//  SpotifyPlaylistListVC.swift
//  Modularm
//
//  Created by Alex Hong on 9/11/2015.
//  Copyright © 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit
import WebImage

let kImageSize = CGSizeMake(70, 70)
let kPlaylistPlaceholderImage = UIImage.imageWithImage(UIImage(named: "placeholder-playlist")!, scaledToSize: kImageSize)

class SpotifyPlaylistListVC: UITableViewController {
   
   var playlists:[SPTPartialPlaylist]?
   var loginHelper:SpotifyLoginHelper?
   
   @IBOutlet weak var loginButton: UIBarButtonItem!
   override func viewDidLoad() {
      super.viewDidLoad()
      
      initUI()
   }
   
   func initUI(){
      if SpotifySesionManager.sharedInstance.hasSavedSession(){
         //Change button title
         loginButton.title = "Log Out"
         //Try fetching data.
         loadPlaylists()
      }
      //do nothing when logged out.
   }
   
   func loadPlaylists(){
      SpotifySesionManager.sharedInstance.fetchUserPlaylist { (optionalList, error) -> () in
         self.playlists = optionalList
         self.tableView.reloadData()
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Left, Right Bar ButtonItem event
   @IBAction func cancelButtonPressed(sender: AnyObject) {
      if let navVC = navigationController as? SpotifyMusicPickerVC {
         navVC.dismissViewControllerAnimated(true, completion: { () -> Void in
            navVC.pickerDelegate?.spotifyMusicPickerDidCancel()
         })
      }
   }
   
   @IBAction func logInButtonPressed(sender: AnyObject) {
      if SpotifySesionManager.sharedInstance.hasSavedSession() {
         //Do LogOut
         //Only need to clear session
         let alertController = UIAlertController(title:nil , message: "Are you sure you want to log out spotify account?", preferredStyle: .Alert)
         alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
         }))
         alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            SpotifySesionManager.sharedInstance.clearSession()
            //when logged out, dismiss view controller.
            self.cancelButtonPressed(sender)
         }))
         presentViewController(alertController, animated: true, completion: nil)
      } else {
         //Try Login here.
         loginHelper = SpotifyLoginHelper(callback: { (success, error) -> () in
            if (success){
               self.loadPlaylists()
               self.loginButton.title = "Log Out"
            } else {
               //Show error message
            }
         })
         loginHelper?.loginFromVC(self)
      }
   }
   
   // MARK: - Table view data source
   override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return playlists?.count ?? 0
   }
   
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("SpotifyPlayListCellIdentifier", forIndexPath: indexPath)
      
      // Configure the cell...
      guard let list = playlists?[indexPath.row] else {
         return cell
      }
      
      // Setup Cell
      cell.textLabel?.text = list.name
      cell.detailTextLabel?.text = "\(list.trackCount) tracks"
      cell.imageView?.image = kPlaylistPlaceholderImage
      if let imageURL = list.smallestImage?.imageURL{
         SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: [], progress: nil, completed: { (image, _, _, _, _) -> Void in
            if image != nil{
               cell.imageView?.image = UIImage.imageWithImage(image, scaledToSize: kImageSize)
            }
         })
      }
      
      return cell
   }
   
   // MARK: - Navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
      guard let cell = sender as? UITableViewCell else{
         return
      }
      
      guard let row = tableView.indexPathForCell(cell)?.row else {
         return
      }
      
      guard let targetVC = segue.destinationViewController as? SpotifyTrackListVC else {
         return
      }
      targetVC.playlist = playlists?[row]
   }
   
   // MARK: - ARC Testing
   deinit{
      print("Deinit Playlist VC")
   }
}
