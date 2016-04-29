//
//  MeditationController.swift
//  Alpha
//
//  Created by Max Yendall on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//


import UIKit

class MeditationController: UIViewController {
    
    // Singleton fetch
    var model = ModelData.sharedInstance;
    // Data pointer to track model
    var dataPointer = 0;
    
    // UI Container Declaration
    @IBOutlet weak var imageView        : UIImageView!;
    @IBOutlet weak var titleField       : UILabel!;
    @IBOutlet weak var descriptionField : UITextView!;
    
    // Handle swipe gestures to flick through meditation techniques
    func handleGesture(sender: UISwipeGestureRecognizer)
    {
        // Handle the direction of the gesture (locked to left and right)
        if (sender.direction == .Left)
        {
            navigatePreviousItem();
        }
        if (sender.direction == .Right)
        {
            navigateNextItem();
        }
    }
    
    // Handle button presses to flick through meditation techniques
    @IBAction func navigateNext(sender: UIButton)
    {
        navigateNextItem();
    }
    @IBAction func navigatePrevious(sender: UIButton)
    {
        navigatePreviousItem();
    }
    
    // Navigation Next function for flicking through meditation techniques
    func navigateNextItem()
    {
        if(dataPointer == model.meditationData.count-1)
        {
            dataPointer = 0;
        }
        else
        {
            dataPointer += 1;
        }
        
        let imageName = model.meditationData[dataPointer].image;
        let imageUI = UIImage(named: imageName);
        imageView.image = imageUI;
        titleField.text = model.meditationData[dataPointer].dataTitle;
        descriptionField.text = model.meditationData[dataPointer].dataBody;
    }
    
    // Navigation Previous function for flicking through meditation techniques
    func navigatePreviousItem()
    {
        if(dataPointer == 0)
        {
            dataPointer = model.meditationData.count-1;
        }
        else
        {
            dataPointer -= 1;
        }
        
        let imageName = model.meditationData[dataPointer].image;
        let imageUI = UIImage(named: imageName);
        imageView.image = imageUI;
        titleField.text = model.meditationData[dataPointer].dataTitle;
        descriptionField.text = model.meditationData[dataPointer].dataBody;
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view to the first instance in the Data Model
        let imageName = model.meditationData.first?.image;
        let imageUI = UIImage(named: imageName!);
        
        imageView.image = imageUI;
        titleField.text = model.meditationData.first?.dataTitle;
        descriptionField.text = model.meditationData.first?.dataBody;
        
        // Set up gesture recognition
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MeditationController.handleGesture(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MeditationController.handleGesture(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}


