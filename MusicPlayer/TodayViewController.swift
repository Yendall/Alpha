//
//  TodayViewController.swift
//  MusicPlayer
//
//  Created by Max Yendall on 18/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit
import NotificationCenter
import MMWormhole

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var isPlaying : Bool = false;
    var stateController : String = "";
    let notificationKey = "com.maxyendall.alpha.notificationKey";
    
    // Grouping and Wormhole variables
    let appGroupID      = "group.maxyendall.alpha.todaywidgetcontainer";
    let wormhole        = MMWormhole(
        applicationGroupIdentifier: "group.maxyendall.alpha.todaywidgetcontainer",
        optionalDirectory: "wormhole"
    );
    
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var pauseImage: UIImageView!
    
    // Function: Create a wormhole which you can pass messages through
    // @return: Wormhole link
    func createWormhole()
    {
        wormhole.listenForMessageWithIdentifier("AVState", listener: {(messageObject) -> Void in
            if let message : AnyObject = messageObject {
                let state = String(message).componentsSeparatedByString(":");
                debugPrint(state[0],state[1]);
                self.stateController = state[1];
                switch(state[0])
                {
                    case("play"):
                        self.playImage.image = UIImage(named: "icoPlayWidget");
                        self.pauseImage.image = UIImage(named: "icoPause");
                        self.stopImage.image = UIImage(named: "icoStop");
                        break;
                    case("pause"):
                        self.pauseImage.image = UIImage(named: "icoPauseWidget");
                        self.playImage.image = UIImage(named: "icoPlay");
                        self.stopImage.image = UIImage(named: "icoStop");
                        break;
                    case("stop"):
                        self.stopImage.image = UIImage(named: "icoStopWidget");
                        self.pauseImage.image = UIImage(named: "icoPause");
                        self.playImage.image = UIImage(named: "icoPlay");
                        break;
                    default:
                        break;
                }
            }
        });
    }
    
    // Function: Play music from either Alpha and Theta depending on identification
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func playMusic(sender: UIButton)
    {
        let state_iden = "play:" + stateController;
        wormhole.passMessageObject(state_iden, identifier: "AVState");
    }
    
    // Function: Pause music from either Alpha and Theta depending on identification
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func pauseMusic(sender: UIButton)
    {
        let state_iden = "pause:"+stateController;
        wormhole.passMessageObject(state_iden, identifier: "AVState");
    }
    
    // Function: Stop music from either Alpha and Theta depending on identification
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func stopMusic(sender: UIButton)
    {
        let state_iden = "stop:"+stateController;
        wormhole.passMessageObject(state_iden, identifier: "AVState");
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        // Create the wormhole
        createWormhole();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.NewData)
    }
    
}
