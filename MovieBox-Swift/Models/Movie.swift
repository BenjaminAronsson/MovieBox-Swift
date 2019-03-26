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
    @objc dynamic var imageUrl : String = ""
    @objc dynamic var summary : String = ""
    @objc dynamic var year : String = ""
    @objc dynamic var imageData = Data()
    @objc dynamic var rating : Double = 0.0
    
    func getImage() -> UIImage? {
        
//        if let im = UIImage.loadImageFromDiskWith(fileurl: imageUrl) {
//            return im
//        }
        
        if let img = UIImage(data: imageData) {
            return img
        }
        
        
         else if let url = NSURL(string: imageUrl) {
            if let data = NSData(contentsOf: url as URL) {
                return UIImage(data: data as Data)!
            }
        }
        return nil
    }
    
    func saveImageLocally() {
        //let data = poster?.pngData()
        //när bilden sätts
        imageData = (poster?.jpegData(compressionQuality: 0.9))!
    }
}
