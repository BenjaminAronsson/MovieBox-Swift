//
//  Movie.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    var title : String
    var poster : UIImage?
    var description : String?
    var year : String
    var rating : Double?
    
    init() {
        title = "Star wars"
        poster = nil
        description = "Irom Parum"
        rating = 3.0
        year = "1999"
    }
    
    convenience init (title : String, year : String, rating : Double) {
        self.init()
        self.title = title
        self.year = year
        self.rating = rating
    }
    
    
    //MARK: -- Dictionary --
    init(data : [String : String]) {
    
        if let title = data["MovieTitle"] {
            self.title = title
        }
        else {
            self.title = "Hidden"
        }
        
        if let year = data["MovieYear"] {
            self.year = year
        }
        else {
            self.year = "0000"
        }
        if let rating = data["MovieRating"] {
            self.rating =  Double(rating)
        }
    //read image
//NSString *imagePath = data[@"MoviePoster"];
//    if (imagePath) {
    //set image
//    self.poster = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
//    }
//    }
    
    }
    
    
    func dictionaryFromObject() -> [String : String] {
    
//    // Get image data
//    NSData *imageData = UIImageJPEGRepresentation(self.poster, 1);
//
//    // Get image path
//    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
//
//    // Write image data to user's folder
//    [imageData writeToFile:imagePath atomically:YES];
//
    //convert rating to string
        let rate : String = "\(self.rating ?? 0)"
    
    //return NSDictionary
    return ["MovieTitle":self.title, "MovieYear":self.year, "MovieRating":rate]
    }

}
