//
//  myDB.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation

class MyDB {
    //singelton
    //private init() {} //This prevents others from using the default '()' initializer for this class.
    //static let sharedInstance = MyDB()
    
    
    static let sharedInstance = MyDB()
    
    init() {
        print("Hello");
    }

    
    var myMovies : [Movie] = []
    var status = "saved"
}

