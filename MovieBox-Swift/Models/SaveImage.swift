//
//  SaveImage.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-20.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    func saveImage() -> String? {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.long
        
        dateformatter.timeStyle = DateFormatter.Style.long
        
        let now = dateformatter.string(from: NSDate() as Date)
        
        let fileName = "favorites/" + now
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = self.jpegData(compressionQuality: 1) else { return fileName}
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        return nil
    }
    
    
    
   static func loadImageFromDiskWith(fileurl: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileurl)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
    }

}
