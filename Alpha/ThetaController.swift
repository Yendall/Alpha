//
//  ThetaController.swift
//  Alpha
//
//  Created by Max Yendall on 29/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import AVFoundation
import MMWormhole

class ThetaController: UIViewController {

    // Singleton fetch
    let db              = LocalDatabaseSingleton.sharedInstance;
    let model           = ModelData.sharedInstance;
    let firebaseModel   = FirebaseController();
    
    // Grouping and Wormhole variables
    let appGroupID      = "group.maxyendall.alpha.todaywidgetcontainer";
    let wormhole        = MMWormhole(
        applicationGroupIdentifier: "group.maxyendall.alpha.todaywidgetcontainer",
        optionalDirectory: "wormhole"
    );
    
    // Data pointer to track model
    var dataPointer = 0;
    var currentMusic = MusicNode(musicID: "", prefix: "", musicURL: "", title: "", liked: false);
    var identifier = "Theta";
    
    // Audio player variables
    var audioPlayer = AVPlayer();
    var isPlaying = false;
    var likedMusic = false;
    
    // Outlets
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    // Function: Create a wormhole which you can pass messages through
    // @return: Wormhole link
    func createWormhole()
    {
        wormhole.listenForMessageWithIdentifier("AVState", listener: {(messageObject) -> Void in
            if let message : AnyObject = messageObject {
                
                // Separate the state into category and AVState
                let state = String(message).componentsSeparatedByString(":");
                debugPrint(state[0],state[1]);
                // Only change the relative view controller
                if(state[1] == "Theta")
                {
                    switch(state[0])
                    {
                    case("play"):
                        self.audioPlayer.play();
                        self.isPlaying = true;
                        self.playImage.image = UIImage(named: "icoPlayColoured");
                        self.pauseImage.image = UIImage(named: "icoPauseGrey");
                        self.stopImage.image = UIImage(named: "icoStopGrey");
                        break
                    case("pause"):
                        self.audioPlayer.pause();
                        self.isPlaying = false;
                        self.pauseImage.image = UIImage(named: "icoPauseColoured");
                        self.playImage.image = UIImage(named: "icoPlayGrey");
                        self.stopImage.image = UIImage(named: "icoStopGrey");
                        break;
                    case("stop"):
                        self.audioPlayer.pause();
                        self.isPlaying = false;
                        self.stopImage.image = UIImage(named: "icoStopColoured");
                        self.pauseImage.image = UIImage(named: "icoPauseGrey");
                        self.playImage.image = UIImage(named: "icoPlayGrey");
                        break;
                    default:
                        break;
                    }
                }
            }
        });
    }
    // Function: A selector for when the user presses the liked button
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func likeSelection(sender: UIButton)
    {
        // Music already liked, if we click it we must delete it in data-chain
        if(likedMusic)
        {
            likeImage.image = UIImage(named: "heartUnselected");
            likedMusic = false;
            likeButton.enabled = false;
            firebaseModel.deleteUserMusic(currentMusic.musicID,prefix: "Theta")
            {
                success in
                self.likeButton.enabled = true;
            }
        }
        else
        {
            likeImage.image = UIImage(named: "heartSelected");
            likedMusic = true;
            likeButton.enabled = false;
            firebaseModel.pushUserMusic(currentMusic)
            {
                success in
                self.likeButton.enabled = true;
            }
            
        }
    }
    // Function: A selector for when the user presses the liked button
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func playMusic(sender: UIButton)
    {
        wormhole.passMessageObject("play:Theta", identifier: "AVState");
    }
    
    // Function: A selector to send information to the Wormhole for the pause state
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func pauseMusic(sender: UIButton)
    {
        if(isPlaying)
        {
            wormhole.passMessageObject("pause:Theta", identifier: "AVState");
        }
    }
    
    // Function: A selector to send information to the Wormhole for the stop state
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func stopMusic(sender: UIButton)
    {
        wormhole.passMessageObject("stop:Theta", identifier: "AVState");
    }
    
    // Function: generates music streaming from a Cloud S3 Instance (at the moment it's just a FTP connection)
    @IBAction func generateMusic(sender: AnyObject)
    {
        // Enable the play button
        playButton.enabled  = true;
        playButton.hidden   = false;
        playImage.hidden    = false;
        pauseImage.hidden   = false;
        stopImage.hidden    = false;
        titleField.hidden   = false;
        likeImage.hidden    = false;
        
        // Check is audio player is currently playing
        if(isPlaying)
        {
            audioPlayer.pause();
            isPlaying = false;
        }
        // Generate random song from data pool
        var randomNumber = Int(arc4random_uniform(UInt32(model.thetaData.count)));
        while(dataPointer == randomNumber)
        {
            randomNumber = Int(arc4random_uniform(UInt32(model.thetaData.count)));
        }
        dataPointer = randomNumber;
        // Set the music URL from the data model
        let musicURL = model.thetaData[randomNumber].musicURL;
        // Create the player item from the URL
        let playerItem = AVPlayerItem(URL:NSURL( string: musicURL )!);
        
        // Enable the audioPlayer settings and play the generated song
        audioPlayer = AVPlayer(playerItem:playerItem);
        audioPlayer.rate = 1.0;
        audioPlayer.pause();
        
        // Set the song title
        titleField.text = model.thetaData[randomNumber].title;
        
        // Flip hidden fields
        titleField.hidden = false;
        // Set current music URL
        currentMusic = MusicNode(
            musicID: String(model.thetaData[randomNumber].musicID),
            prefix: "Theta",
            musicURL: model.thetaData[randomNumber].musicURL,
            title: model.thetaData[randomNumber].title,
            liked: false
        )
        
        // Search for quote existence and set the like button
        let liked = db.searchMusic(currentMusic.musicID, _prefix: currentMusic.prefix);
        if(liked)
        {
            likeImage.image = UIImage(named: "heartSelected");
            likedMusic = true;
        }
        else
        {
            likeImage.image = UIImage(named: "heartUnselected");
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the wormhole
        createWormhole();
        // Start with all images and buttons disable
        playButton.enabled  = false;
        playButton.hidden   = true;
        playImage.hidden    = true;
        pauseImage.hidden   = true;
        stopImage.hidden    = true;
        titleField.hidden   = true;
        likeImage.hidden    = true;
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

