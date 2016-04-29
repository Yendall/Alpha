//
//  ThetaController.swift
//  Alpha
//
//  Created by Max Yendall on 29/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import AVFoundation

class ThetaController: UIViewController {

    // Singleton fetch
    var model = ModelData.sharedInstance;
    
    // Data pointer to track model
    var dataPointer = 0;
    
    // Audio player variables
    var audioPlayer = AVPlayer();
    var isPlaying = false;
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleField: UILabel!
    
    @IBAction func pausePlayMusic(sender: UIButton)
    {
        if(isPlaying)
        {
            audioPlayer.pause();
            playButton.setTitle("P L A Y",forState: UIControlState.Normal);
            isPlaying = false;
        }
        else
        {
            audioPlayer.play();
            playButton.setTitle("P A U S E",forState: UIControlState.Normal);
            isPlaying = true;
        }
    }
    
    // Function: generates music streaming from a Cloud S3 Instance (at the moment it's just a FTP connection)
    @IBAction func generateMusic(sender: AnyObject)
    {
        // Check is audio player is currently playing
        if(isPlaying)
        {
            audioPlayer.pause();
            playButton.setTitle("P L A Y",forState: UIControlState.Normal);
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
        playButton.hidden = false;
        titleField.hidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

