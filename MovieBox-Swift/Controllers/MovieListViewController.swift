//
//  FirstViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-12.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {
    
    var favoriteMovies: [Movie] = [];
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoriteMovies = MyDB.sharedInstance.myMovies
        tableView.reloadData()
    }
    
    //MARK: -- tableviewController --
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Movie *m = _movies[indexPath.row];
        let m = favoriteMovies[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.setMovie(containingMovie: m)
        cell.canAdd(button: false)
        //cell.ratingDelegate = self;
        return cell;
    }


}

