//
//  SecondViewController.swift
//  MovieBox-Swift
//
//  Created by Benjamin on 2019-03-12.
//  Copyright © 2019 se.Benjamin.Aronsson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchMovieViewController: UITableViewController {
    
    @IBOutlet weak var searchField: UITextField!
    
    
    var filteredMovies : [Movie] = []

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if filteredMovies.count < 1 {
            
            //default -- star wars
            searchField.text = "star wars"
            SearchButtonPressed(self)
            searchField.text = ""
        }
    }
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    //https://www.omdbapi.com/?s=%@&page=%ld&apikey=e3770048
    
    let API_KEY = "e3770048"
    let MOVIE_URL = "https://www.omdbapi.com/"
    let APP_ID = "8ef1d43040955dcd731d9059d85ce0b8"
    @IBAction func SearchButtonPressed(_ sender: Any) {
        
        //get searchterm
        if let searchTerm = searchField.text {
            
            //create parameters
            let page : String = String(1)
            let params : [String : String] = ["page" : page, "s" : searchTerm, "apikey" : API_KEY]
            
            getMovieData(url: MOVIE_URL, parameters: params)
            
        }
        
        //dismisses keyboard
        searchField.resignFirstResponder()
    }
    
    
    //MARK: -- tableviewController --
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Movie *m = _movies[indexPath.row];
        let m = filteredMovies[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.setMovie(containingMovie: m)
        //cell.ratingDelegate = self;
        return cell;
    }
    
    //MARK: -- Networking --
    
    func getMovieData(url: String, parameters: [String : String]) {
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess {
                print("Success getting the Movie data")

                let movieJSON : JSON = JSON(response.result.value!)
                //print(movieJSON)
                self.updateMovieData(json: movieJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                //self.cityLabel.text = "Connection issues"
                self.view.backgroundColor = UIColor.red
            }
        }
    }
    
     //MARK: -- JSON Parsing --
    
    func updateMovieData(json: JSON) {
        
        //clear list
        filteredMovies.removeAll()
        
        if let movieArray = json["Search"].array {
            
            //adds all movies
            for i in 0..<(movieArray.count) {
               
                //get values
                let title = movieArray[i]["Title"].string!
                let year = movieArray[i]["Year"].string!
                let rating = Double(arc4random_uniform(5));
                
                //create object
                let m = Movie(title: title, year: year, rating: rating)
                
                //get poster
                let posterURL = movieArray[i]["Poster"].string
                
                if let url = NSURL(string: posterURL!) {
                    if let data = NSData(contentsOf: url as URL) {
                        m.poster = UIImage(data: data as Data)
                    }
                }
                
                filteredMovies.append(m)
            }
            
            tableView.reloadData()
        }
        else {
            //create object
        let m = Movie(title: "NO MOIVES FOUND", year: "", rating: 0.0)
        filteredMovies.append(m)
        print("Movies unavailable")
        tableView.reloadData()
        }
    }
    
    //MARK: -- prep for segue --
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchToDetail" {
            let dcController = segue.destination as! DetailedMovieViewController
            if let selectedIndexPath : Int = self.tableView?.indexPathForSelectedRow?.row {
            dcController.selectedMovie = filteredMovies[selectedIndexPath]
            }
        }
    }
}




