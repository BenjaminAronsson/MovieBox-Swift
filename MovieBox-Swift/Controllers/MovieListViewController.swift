//
//  FirstViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-12.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import RealmSwift
import RealmSwift

class MovieListViewController: UITableViewController {
    
    var favoriteMovies : Results<Movie>?
    
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMovies()
    }
    
    //MARK: -- tableviewController --
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        if let selectedMovie = favoriteMovies?[indexPath.row] {
            
            cell.setMovie(containingMovie: selectedMovie)
            cell.canAdd(button: false)
            //cell.accessoryType = Item.done ? .checkmark : .none
        } else {
            cell.canAdd(button: false)
            cell.titleLabel.text = "No movies added yet"
            cell.yearLabel.text = ""
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func loadMovies() {
        
        favoriteMovies = realm.objects(Movie.self)
        tableView.reloadData()
    }
}

