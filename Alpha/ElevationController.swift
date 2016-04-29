//
//  ElevationController.swift
//  Alpha
//
//  Created by Max Yendall on 30/03/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class ElevationController: UIViewController {
    
    // Singleton access
    var model = ModelData.sharedInstance;
    // Data pointer to track model
    var imagePointer = 0;
    var quotePointer = 0;
    
    // Declare IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quotationView: UITextView!
    @IBOutlet weak var authorField: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    // Function: Generates randomised quotes and images on click
    @IBAction func generateQuotation(sender: UIButton)
    {
        // Create randomised number for image and quote
        var randomImage  = Int(arc4random_uniform(UInt32(model.imageData.count)));
        var randomQuote  = Int(arc4random_uniform(UInt32(model.elevationData.count)));
        
        // If the previously generated value is the same as the current value, reshuffle (Image)
        while(imagePointer == randomImage)
        {
            randomImage = Int(arc4random_uniform(UInt32(model.imageData.count)));
        }
        imagePointer = randomImage;
        
        // If the previously generated value is the same as the current value, reshuffle (Quote)
        while(quotePointer == randomQuote)
        {
            randomQuote = Int(arc4random_uniform(UInt32(model.elevationData.count)));
        }
        quotePointer = randomQuote;
        
        // Assign image source and quotation field
        let imageName = model.imageData[randomImage].imageSRC;
        let imageUI = UIImage(named: imageName);
        
        // Assign fields
        imageView.image = imageUI;
        quotationView.text = model.elevationData[randomQuote].quotation;
        authorField.text = model.elevationData[randomQuote].author;
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set app delegate property to disable use of landscape mode
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldSupportAllOrientation = false
        
        // Set the view to the first instance in the Data Model
        let imageName = model.imageData.first?.imageSRC;
        let imageUI = UIImage(named: imageName!);
        
        imageView.image = imageUI;
        quotationView.text = model.elevationData.first?.quotation;
        authorField.text = model.elevationData.first?.author;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}