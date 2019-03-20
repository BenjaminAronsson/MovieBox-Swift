//
//  Movie.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Movie : Object {
    
    @objc dynamic var title : String = ""
     var poster : UIImage?
    //@objc dynamic var description : String = ""
    @objc dynamic var year : String = ""
    @objc dynamic var rating : Double = 0.0
    
//    init() {
//        title = "Star wars"
//        poster = nil
//        description = "Irom Parum"
//        rating = 3.0
//        year = "1999"
//    }
//
//    convenience init (title : String, year : String, rating : Double) {
//        self.init()
//        self.title = title
//        self.year = year
//        self.rating = rating
//    }
    
    
    func getImage() {
        
    }
    
    
    //read image
//NSString *imagePath = data[@"MoviePoster"];
//    if (imagePath) {
    //set image
//    self.poster = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
//    }
//    }
}
