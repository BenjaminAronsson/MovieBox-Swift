//
//  DetailedMovieViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-13.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import STRatingControl

class DetailedMovieViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rating: STRatingControl!
    
    var selectedMovie : Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = selectedMovie {
        // Do any additional setup after loading the view.
            
            print("movie found")
            if let img = movie.getImage() {
                print("image found")
                posterImage.image = img
            }
            else {
                print("no image found")
                posterImage.image = UIImage.init(named: "missingImage")
            }
            
            //MARK : ---------- TODO testing -----
        titleLabel.text = movie.title
        yearLabel.text = movie.year            //Change
        descriptionTextView.text = movie.summary
        rating.maxRating = 5
        rating.rating = Int(movie.rating)
            
            if titleLabel.text == nil {
            titleLabel.text = "Where is the titel" }
        }
        else {
            print("no movie found")
            titleLabel.text = "Title"
            posterImage.image = UIImage.init(named: "missingImage")
        }
    }
}
