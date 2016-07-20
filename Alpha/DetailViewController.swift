//
//  DetailViewController.swift
//  Alpha
//
//  Created by Max Yendall on 22/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    var headerImageName:String?;
    var _title:String?;
    var first:String?;
    var second:String?;
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerImage.image   = UIImage(named: headerImageName!);
        titleLabel.text     = _title;
        firstLabel.text     = first;
        secondLabel.text    = second;
        firstLabel.sizeToFit();
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
