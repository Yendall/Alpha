//
//  AlphaController.swift
//  Alpha
//
//  Created by Max Yendall on 29/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MMWormhole

class AlphaController: UIViewController {

    // Singleton fetch
    var model           = ModelData.sharedInstance;
    var db              = LocalDatabaseSingleton.sharedInstance;
    var firebaseModel   = FirebaseController();
    
    // Grouping and Wormhole variables
    let appGroupID      = "group.maxyendall.alpha.todaywidgetcontainer";
    let wormhole        = MMWormhole(
        applicationGroupIdentifier: "group.maxyendall.alpha.todaywidgetcontainer",
        optionalDirectory: "wormhole"
    );
    
    // Data pointer to track model
    var dataPointer = 0;
    var currentMusic = MusicNode(musicID: "", prefix: "", musicURL: "", title: "", liked: false);
    
    // Audio player variables
    var audioPlayer = AVPlayer();
    var isPlaying = false;
    var likedMusic = false;
    
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var pauseImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    // Function: Create a wormhole which you can pass messages through
    // @return: Wormhole link
    func createWormhole()->Bool
    {
        wormhole.listenForMessageWithIdentifier("AVState", listener: {(messageObject) -> Void in
            if let message : AnyObject = messageObject {
                
                // Separate the state into category and AVState
                let state = String(message).componentsSeparatedByString(":");
                debugPrint(state[0],state[1])
                if(state[1] == "Alpha")
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
        
        return true;
    }
    // Function: A selector for when the user presses the liked button
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func likeSelection(sender: UIButton)
    {
        // If it is already liked
        if(likedMusic)
        {
            likeImage.image = UIImage(named: "heartUnselected");
            likedMusic = false;
            likeButton.enabled = false;
            firebaseModel.deleteUserMusic(currentMusic.musicID,prefix: "Alpha")
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
    // Function: A selector to send information to the Wormhole for the play state
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func playMusic(sender: UIButton)
    {
        wormhole.passMessageObject("play:Alpha", identifier: "AVState");
    }
    
    // Function: A selector to send information to the Wormhole for the pause
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func pauseMusic(sender: UIButton)
    {
        
        if(isPlaying)
        {
            wormhole.passMessageObject("pause:Alpha", identifier: "AVState");
        }
    }
    
    // Function: A selector to send information to the Wormhole for the stop state
    // @params: UIButton : Press Down
    // @return: void
    @IBAction func stopMusic(sender: UIButton)
    {
        wormhole.passMessageObject("stop:Alpha", identifier: "AVState");
    }
    
    // Function: generate music from HTTPS link
    // @params: UIButton : Push Down
    // @return: void
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
        var randomNumber = Int(arc4random_uniform(UInt32(model.alphaData.count)));
        while(dataPointer == randomNumber)
        {
            randomNumber = Int(arc4random_uniform(UInt32(model.alphaData.count)));
        }
        dataPointer = randomNumber;
        // Set the music URL from the data model
        let musicURL = model.alphaData[randomNumber].musicURL;
        // Create the player item from the URL
        let playerItem = AVPlayerItem(URL:NSURL( string: musicURL )!);
        
        // Enable the audioPlayer settings and play the generated song
        audioPlayer = AVPlayer(playerItem:playerItem);
        audioPlayer.rate = 1.0;
        audioPlayer.pause();
        
        // Set the song title
        titleField.text = model.alphaData[randomNumber].title;
        
        // Flip hidden fields
        titleField.hidden = false;
        // Set current music URL
        currentMusic = MusicNode(
            musicID: String(model.alphaData[randomNumber].musicID),
            prefix: "Alpha",
            musicURL: model.alphaData[randomNumber].musicURL,
            title: model.alphaData[randomNumber].title,
            liked: false
        )
        
        // Search for quote existence and set the like button
        let liked = db.searchMusic(currentMusic.musicID,_prefix: currentMusic.prefix);
        if(liked)
        {
            likeImage.image = UIImage(named: "heartSelected");
            likedMusic = true;
        }
        else
        {
            likeImage.image = UIImage(named: "heartUnselected");
            likedMusic = false;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the wormhole link
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