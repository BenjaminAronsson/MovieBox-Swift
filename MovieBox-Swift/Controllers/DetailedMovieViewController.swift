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
        posterImage.image = movie.poster
            
            //MARK : ---------- TODO testing -----
        titleLabel.text = movie.title
        yearLabel.text = movie.title            //Change
        descriptionTextView.text = movie.year
        rating.maxRating = 5
        
            if let r = movie.rating {
                rating.rating = Int(r)
            }
            
            
            if titleLabel.text == nil {
                titleLabel.text = "Where is the titel" }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
