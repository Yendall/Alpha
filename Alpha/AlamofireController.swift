//
//  AlamofireController.swift
//  Alpha
//
//  Created by Max Yendall on 14/05/2016.
//  Copyright © 2016 RMIT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class AlamofireController
{
    // Singleton Reference
    let db = LocalDatabaseSingleton.sharedInstance;
    
    // Define the API key to TheySaidSo REST API
    let apiKey : String;
    let baseQuote : String;
    
    init()
    {
        // Initialise the call base and API key
        apiKey = "YaA_9mvfkwd9ccK_LkDTpgeF";
        baseQuote = "http://quotes.rest/quote.json?api_key=" + apiKey;
    }
    
    // Obtain a random quote from TheySaidSo based on category
    // @params: category : String, completionHandler with Result : apiQuote
    // @return: apiQuote Object
    func getQuote(category : String, completion: (result: apiQuote) -> Void)
    {
        Alamofire.request(.GET,baseQuote,parameters: ["category" : category,"max_length" : "100"]).response
            { (request,reponse,data,error) in
                
                let json = JSON(data: data!);
                // Check if this exists in the user storage already
                // if it does, set it as liked
                let liked = self.db.searchQuotation(json["contents"]["id"].string!);
                
                // Create apiQuote object for return upon completion
                let quote = apiQuote(
                    id          :   json["contents"]["id"].string!,
                    quote       :   json["contents"]["quote"].string!,
                    author      :   json["contents"]["author"].string!,
                    liked       :   liked,
                    category    :   category
                );
                
                // Check if completed. The iterations are finished when the JSON is completed
                // return the quote object
                completion(result: quote);
        }
    }
}

// apiQuote class for storing results from JSON
class apiQuote
{
    var id          : String;
    var quote       : String;
    var author      : String;
    var liked       : Bool;
    var category    : String;
    
    // Initialise 'liked' to false, as this is altered later. 
    // All quotes are assumed unliked when the session starts
    init(id: String, quote: String, author: String, liked: Bool, category : String)
    {
        self.id = id;
        self.quote = quote;
        self.author = author;
        self.liked = liked;
        self.category = category;
    }
}