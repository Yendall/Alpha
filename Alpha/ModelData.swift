//
//  ModelData.swift
//  Alpha
//
//  Created by Max Yendall on 2/04/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import UIKit

// Load all model data from JSON files for this assignment, this will be converted to a database
// later.

public class ModelData
{
    // Singleton use
    static let sharedInstance = ModelData();
    
    // SerializeJSON on first time initialisation
    private init()
    {
        serializeJSON();
    }
    
    // Default data models for each section
    var meditationData  = [MeditationData]();
    var elevationData   = [ElevationData]();
    var alphaData       = [AlphaData]();
    var thetaData       = [ThetaData]();
    var imageData       = [ImageData]();
    
    // Function: Serializes JSON data and places into appropriate data models which are accessed through a
    // Singleton Instance
    func serializeJSON()
    {
        // Declare Meditation, Elevation, Alpha and Theta Datasets
        let dataSets : [String] = ["meditationData","elevationData","alphaData","thetaData","imageData"];
        
        for dataTitle in dataSets
        {
            // JSON Deserialization and Parsing from local files (this will be expanded to JSON trees Firebase)
            if let url = NSBundle.mainBundle().URLForResource(dataTitle, withExtension: "json") {
                if NSFileManager.defaultManager().fileExistsAtPath(url.path!)
                {
                    // File has been found, read the contents and serialize the data based on the data set identifier.
                    let data = NSData(contentsOfURL: url);
                    do
                    {
                        // Create JSON data object from NSData model
                        let object = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        if let dictionary = object as? [String: AnyObject]
                        {
                            // Add data to data models relative to their identifier
                            switch dataTitle
                            {
                                case "meditationData":
                                    readJSONObject(dictionary,identifier: dataTitle);
                                case "elevationData":
                                    readJSONObject(dictionary,identifier: dataTitle);
                                case "alphaData":
                                    readJSONObject(dictionary,identifier: dataTitle);
                                case "thetaData":
                                    readJSONObject(dictionary,identifier: dataTitle);
                                case "imageData":
                                    readJSONObject(dictionary,identifier: dataTitle);
                                default:
                                    break;
                            }
                            
                        }
                    } catch{
                        // File IO Error Handling needs to be implemented here
                    }
                }
            }
        }
    }
    
    
    // Function: Reads JSON Object into guarded immutable variables which are inserted into an appropriate
    // data model and appended to storage depending on the identifier passed in.
    func readJSONObject(object: [String: AnyObject],identifier: String)
    {
        // If the file has no data, return cleanly and display an error to the debug terminal
        guard let data = object["dataSet"] as? [[String: AnyObject]] else
        {
            debugPrint("file is empty");
            _ = "Empty Data";
            return;
        }
        // Loop through the data in each node and create objects relative to the identifier and append to the data storage.
        for dataNode in data
        {
            
            switch identifier
            {
                case "meditationData":
                    guard
                        let index = dataNode["index"] as? String,
                        let title = dataNode["title"] as? String,
                        let image = dataNode["image"] as? String,
                        let description = dataNode["description"] as? String
                        else
                    {
                        break;
                    }
                    let newData = MeditationData(index: Int(index)!,image: image,dataTitle: title,dataBody: description);
                    meditationData.append(newData);
                
                case "elevationData":
                    guard
                        let index = dataNode["index"] as? String,
                        let quotation = dataNode["quotation"] as? String,
                        let author = dataNode["author"] as? String
                        else
                    {
                        break;
                    }
                    let newData = ElevationData(index: Int(index)!,quotation: quotation,author: author);
                    elevationData.append(newData);
                
                // Alpha data will be changed later to use a music object, which is obtained through
                // data scraping. For now, it is hard-coded in JSON.
                case "alphaData":
                    guard
                        let index = dataNode["index"] as? String,
                        let imageURL = dataNode["imageURL"] as? String,
                        let title = dataNode["title"] as? String,
                        let musicURL = dataNode["musicURL"] as? String
                    else
                    {
                        break;
                    }
                    
                    let newData = AlphaData(index: Int(index)!,imageURL: imageURL,title: title, musicURL: musicURL);
                    alphaData.append(newData);
                
                case "thetaData":
                    guard
                        let index = dataNode["index"] as? String,
                        let imageURL = dataNode["imageURL"] as? String,
                        let title = dataNode["title"] as? String,
                        let musicURL = dataNode["musicURL"] as? String
                    else
                    {
                        break;
                    }
                    
                    let newData = ThetaData(index: Int(index)!, imageURL: imageURL, title: title, musicURL: musicURL);
                    thetaData.append(newData);
                
                case "imageData":
                    guard
                        let index = dataNode["index"] as? String,
                        let imageSRC = dataNode["imageSRC"] as? String
                    else
                    {
                        break;
                    }
                    let newData = ImageData(index: Int(index)!, imageSRC: imageSRC);
                    imageData.append(newData);
                default:
                    break
                
            }
        }
    }
}

// Extension for CA Layer to define a borders colour on a button
extension CALayer
{
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.CGColor
        }
        
        get {
            return UIColor(CGColor: self.borderColor!)
        }
    }
}

// String extension to add a String function to encrypt using a key.
extension String
{
    func encryptXOR(key: UInt8) -> String
    {
        return String(bytes: self.utf8.map{$0 ^ key}, encoding: NSUTF8StringEncoding) ?? ""
    }
}

// Meditation Data Class (this will be modified later)
class MeditationData
{
    var index       :   Int;
    var image       :   String;
    var dataTitle   :   String;
    var dataBody    :   String;
    
    init(index: Int, image: String, dataTitle: String, dataBody: String)
    {
        self.index = index;
        self.image = image;
        self.dataTitle = dataTitle;
        self.dataBody = dataBody;
    }
    
}

// Elevation Data Class (this will be modified later)
class ElevationData
{
    var index       :   Int;
    var quotation   :   String;
    var author      :   String;
    
    init(index: Int, quotation: String, author: String)
    {
        self.index = index;
        self.quotation = quotation;
        self.author = author;
    }
}

// Theta Data Class (this will be modified later)
class ThetaData
{
    var index       :   Int;
    var imageURL    :   String;
    var title       :   String;
    var musicURL    :   String;
    
    init(index: Int, imageURL: String, title: String, musicURL: String)
    {
        self.index = index;
        self.imageURL = imageURL;
        self.title = title;
        self.musicURL = musicURL;
    }
}

// Alpha Data Class (this will be modified later)
class AlphaData
{
    var index       :   Int;
    var imageURL    :   String;
    var title       :   String;
    var musicURL    :   String;
    
    init(index: Int, imageURL: String,title: String, musicURL: String)
    {
        self.index = index;
        self.imageURL = imageURL;
        self.title = title;
        self.musicURL = musicURL;
    }
}

// Image Data Class
class ImageData
{
    var index       :   Int;
    var imageSRC    :   String;
    
    init(index: Int, imageSRC: String)
    {
        self.index = index;
        self.imageSRC = imageSRC;
    }
}