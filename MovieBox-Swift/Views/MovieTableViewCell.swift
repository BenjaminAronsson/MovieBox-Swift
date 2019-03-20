//
//  MovieTableViewCell.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit 

class MovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var movie : Movie = Movie()
    

    @IBAction func addButtonPressed(_ sender: Any) {
       
        //added movie to list
        let db = MyDB.sharedInstance
        db.myMovies.append(movie)
        print("Movie added to list")
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
        if let img = containingMovie.poster {
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
