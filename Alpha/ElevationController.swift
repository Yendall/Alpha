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
    let db              = LocalDatabaseSingleton.sharedInstance;
    let model           = ModelData.sharedInstance;
    let alamofireModel  = AlamofireController();
    let firebaseModel   = FirebaseController();
    
    // Data pointer to track model
    var imagePointer = 0;
    var quotePointer = 0;
    
    // Pointer to track if quote is already liked
    var likedQuote = false;
    
    // Category variable for tracking user input
    var category: Category = Category.unselected;
    var currentQuote = apiQuote(id: "",quote: "",author: "",liked: false,category: "");
    
    // Declare IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var artButton: UIButton!
    @IBOutlet weak var lifeButton: UIButton!
    @IBOutlet weak var inspireButton: UIImageView!
    
    @IBOutlet weak var quotationView: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var artImage: UIImageView!
    @IBOutlet weak var lifeImage: UIImageView!
    @IBOutlet weak var inspireImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    // Enumeration to represent a category
    enum Category : Int
    {
        case art=1,life,inspire,unselected;
    }
    
    // Function: A selector for when the user presses the liked button
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func likeSelection(sender: UIButton)
    {
        // If it is already liked
        if(likedQuote)
        {
            likeImage.image = UIImage(named: "heartUnselected");
            likedQuote = false;
            likeButton.enabled = false;
            firebaseModel.deleteUserQuote(currentQuote.id)
            {
                success in
                self.likeButton.enabled = true;
            }
        }
        else
        {
            likeImage.image = UIImage(named: "heartSelected");
            likedQuote = true;
            likeButton.enabled = false;
            firebaseModel.pushUserQuote(currentQuote)
            {
                success in
                    self.likeButton.enabled = true;
            }
            
        }
    }
    
    // Function: Selector for the Art Category of quotations. Used for user-driven API calls
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func artSelection(sender: UIButton)
    {
        if(category == .art)
        {
            category = Category.unselected;
            artImage.image = UIImage(named: "icoArtUncoloured");
        }
        else
        {
            artImage.image = UIImage(named: "icoArtColoured");
            lifeImage.image = UIImage(named: "icoLifeUncoloured");
            inspireImage.image = UIImage(named: "icoInspireUncoloured");
            
            category = Category.art;
        }
    }
    
    // Function: Selector for the Life Category of quotations. Used for user-driven API calls
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func lifeSelection(sender: UIButton)
    {
        if(category == .life)
        {
            category = Category.unselected;
            lifeImage.image = UIImage(named: "icoLifeUncoloured");
        }
        else
        {
            lifeImage.image = UIImage(named: "icoLifeColoured");
            artImage.image = UIImage(named: "icoArtUncoloured");
            inspireImage.image = UIImage(named: "icoInspireUncoloured");
            
            category = Category.life;
        }
    }
    
    // Function: Selector for the Inspire Category of quotations. Used for user-driven API calls
    // @params: UIButton : Touch Down
    // @return: void
    @IBAction func inspireSelection(sender: UIButton)
    {
        if(category == .inspire)
        {
            category = Category.unselected;
            inspireImage.image = UIImage(named: "icoInspireUncoloured");
        }
        else
        {
            inspireImage.image = UIImage(named: "icoInspireColoured");
            lifeImage.image = UIImage(named: "icoLifeUncoloured");
            artImage.image = UIImage(named: "icoArtUncoloured");
            
            category = Category.inspire;
        }
    }
    
    // Set quotation fields including like button
    // @params: quote : apiQuote
    // @return: void
    func setQuote(quote : apiQuote)
    {
        
        // Create randomised number for image and quote
        var randomImage  = Int(arc4random_uniform(UInt32(model.imageData.count)));
        let quotation = quote.quote;
        let author = quote.author;
        var set_text : String;
        
        // Set the current quote for reference
        currentQuote = quote;
        
        if(!author.isEmpty)
        {
            set_text = quotation + "\n\n" + author;
        }
        else
        {
            set_text = quotation;
        }
        // Search for quote existence and set the like button
        let liked = db.searchQuotation(quote.id);
        if(liked)
        {
            likeImage.image = UIImage(named: "heartSelected");
            likedQuote = true;
        }
        else
        {
            likeImage.image = UIImage(named: "heartUnselected");
            likedQuote = false;
        }
        
        // If the previously generated value is the same as the current value, reshuffle (Image)
        while(imagePointer == randomImage)
        {
            randomImage = Int(arc4random_uniform(UInt32(model.imageData.count)));
        }
        
        imagePointer = randomImage;
        quoteLabel.sizeToFit();
        quoteLabel.text = set_text;
        quoteLabel.textAlignment = .Center;
        
        // Assign image source and quotation field
        let imageName = model.imageData[randomImage].imageSRC;
        let imageUI = UIImage(named: imageName);
        progressIndicator.stopAnimating();
        progressIndicator.hidden = true;
        quotationView.hidden = false;
        
        if !(UIDevice.currentDevice().orientation.isLandscape.boolValue)
        {
            imageView.image = imageUI;
        }
    }
    // Function: Fetches a quote based on it's category
    // @params: category : Category
    // @return: Quote Model Object
    func fetchQuote(category : Category)
    {
        // Start animating progress indicator as the quote is fetched
        progressIndicator.startAnimating();
        switch(category)
        {
            case .art:
                
                alamofireModel.getQuote("art")
                {
                    (result: apiQuote) in
                        self.setQuote(result);
                }
            case .inspire:
                
                alamofireModel.getQuote("inspire")
                {
                    (result: apiQuote) in
                        self.setQuote(result);
                }
            case .life:
                
                alamofireModel.getQuote("life")
                {
                    (result: apiQuote) in
                        self.setQuote(result);
                }
            case .unselected:
                
                alamofireModel.getQuote("inspire")
                {
                    (result: apiQuote) in
                        self.setQuote(result);
                }
        }
    }
    
    // Function: Generates randomised quotes and images on click
    @IBAction func generateQuotation(sender: UIButton)
    {
        // Begin quote fetching from Alamofire based on the current selection. Default to the 
        // category 'Inspire' if nothing is selected. We don't want exceptions
        fetchQuote(category);
        likeImage.hidden = false;
        progressIndicator.hidden = false;
        quotationView.hidden = true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set the view to the first instance in the Data Model
        let imageName = model.imageData.first?.imageSRC;
        let imageUI = UIImage(named: imageName!);
        likeImage.hidden = true;
        
        if !(UIDevice.currentDevice().orientation.isLandscape.boolValue)
        {
            imageView.image = imageUI;
        }
        quoteLabel.text = ("Touch\n'G E N E R A T E'\nto begin your discovery");
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Orientation listener to change the image view depending on rotation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        // If the device is in landscape
        if UIDevice.currentDevice().orientation.isLandscape.boolValue
        {
            if(quoteLabel != nil)
            {
                quoteLabel.textAlignment = .Center;
            }
            // Check that the view has actually loaded before attempting to
            // alter it
            if(imageView != nil)
            {
                // This allows the image to remain on iPads as there is much
                // more pixel real-estate
                if(UIDevice.currentDevice().userInterfaceIdiom == .Phone)
                {
                    imageView.hidden = true;
                }
            }
            
        }
        else
        {
            // If the device is portrait maintain the imageView
            if(imageView != nil)
            {
                imageView.hidden = false;
            }
            
        }
    }
}