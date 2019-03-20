//
//  MovieTableViewCell.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import RealmSwift

class MovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var movie : Movie = Movie()
    
    var favoriteMovies : Results<Movie>?
    
    let realm = try! Realm()
    

    @IBAction func addButtonPressed(_ sender: Any) {
       
        
        
        do {
            try self.realm.write {
               realm.add(movie)
                //added movie to list
                print("Movie added to list")
            }
        } catch {
            print("Error saving item \(error)")
        }
    }
    
    //MARK: -- add button --
    func canAdd(button: Bool) {
        self.addButton.isHidden = !button
    }
    
    //MARK: -- configuring cell --
    
    func setMovie(containingMovie : Movie) {
        movie = containingMovie
        titleLabel.text = containingMovie.title
        yearLabel.text = containingMovie.year
        
        if let img = containingMovie.getImage() {
            posterImage.image = img
        }
        else {
            posterImage.image = UIImage.init(named: "missingImage")
        }
    }
    
    //MARK: -- thing --
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
