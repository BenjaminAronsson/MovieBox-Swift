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
import SwipeCellKit

class MovieListViewController: UITableViewController {
    
    var favoriteMovies : Results<Movie>?
    
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMovies()
    }
    
    //MARK: -- tableviewController --
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if favoriteMovies?.count == 0 {
            self.tableView.setEmptyMessage("No movies added yet, but try searching for some new ones under the search tab")
        } else {
            self.tableView.restore()
        }
        
        return favoriteMovies?.count ?? 0
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
        
        cell.delegate = self
        
        return cell
    }
    
    func loadMovies() {
        
        favoriteMovies = realm.objects(Movie.self)
        tableView.reloadData()
    }
    
    //MARK: -- prep for segue --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "listToDetail" {
            let dcController = segue.destination as! DetailedMovieViewController
            if let selectedIndexPath : Int = self.tableView?.indexPathForSelectedRow?.row {
                dcController.selectedMovie = favoriteMovies![selectedIndexPath]
            }
        }
    }
}

//MARK: - searchbar
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        favoriteMovies = favoriteMovies?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! == 0 {
            loadMovies()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//MARK: - swipecell
extension MovieListViewController : SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
     
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, IndexPath) in
            
            if let movieForDeletion = self.favoriteMovies?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(movieForDeletion)
                    }
                    self.tableView.reloadData()
                } catch {
                    print("error deleting item")
                }
            }
            print("delete")
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}


